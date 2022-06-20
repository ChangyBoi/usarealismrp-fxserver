local FIREMODE_SELECTOR_KEY = 319 -- should be synced with Config.SelectorKey

local ranOutOfAmmo = false

local FULL_AUTO_WEPS = {
    "WEAPON_MINISMG",
    "WEAPON_SMG",
    "WEAPON_MICROSMG",
    "WEAPON_SMG_MK2",
    "WEAPON_ASSAULTSMG",
    "WEAPON_MG",
    "WEAPON_COMBATMG",
    "WEAPON_COMBATMG_MK2",
    "WEAPON_COMBATPDW",
    "WEAPON_APPISTOL",
    "WEAPON_MACHINEPISTOL",
    "WEAPON_ASSAULTRIFLE",
    "WEAPON_ASSAULTRIFLE_MK2",
    "WEAPON_CARBINERIFLE",
    "WEAPON_CARBINERIFLE_MK2",
    "WEAPON_ADVANCEDRIFLE",
    "WEAPON_SPECIALCARBINE",
    "WEAPON_BULLPUPRIFLE",
    "WEAPON_COMPACTRIFLE",
    "WEAPON_SPECIALCARBINE_MK2",
    "WEAPON_BULLPUPRIFLE_MK2"
}

local MAGAZINE_LOAD_TIME = 13000
local MAGAZINE_LOAD_ANIM = {
    DICT = "weapons@pistol@ap_pistol_str",
    NAME = "reload_aim"
}

RegisterNetEvent("ammo:playMagazineFillingAnimation")
AddEventHandler("ammo:playMagazineFillingAnimation", function()
    playAnimation(MAGAZINE_LOAD_ANIM.DICT, MAGAZINE_LOAD_ANIM.NAME, MAGAZINE_LOAD_TIME, 48, "Loading Mag")
end)

RegisterNetEvent("ammo:reloadMag")
AddEventHandler("ammo:reloadMag", function(data)
    if not exports["usa_stretcher"]:IsInStretcher() then
        local myped = PlayerPedId()
        local currentWeaponHash = GetSelectedPedWeapon(myped)
        local ammoCountToUse = nil
        if type(data) == "table" then
            ammoCountToUse = data.currentCapacity
        elseif type(data) == "number" then
            ammoCountToUse = data
        end
        -- play reload animation --
        playAnimation("cover@weapon@machinegun@combat_mg_str", "low_reload_left", 2000, 48, "Reloading")
        -- set / remove extended mag if applicable --
        if type(data) == "table" then
            if data.magComponent then
                GiveWeaponComponentToPed(myped, currentWeaponHash, GetHashKey(data.magComponent))
            else
                if WEP_EXTENDED_MAG_COMPONENTS[currentWeaponHash] then
                    for index, hash in pairs(WEP_EXTENDED_MAG_COMPONENTS[currentWeaponHash]) do
                        hash = GetHashKey(hash)
                        RemoveWeaponComponentFromPed(myped, currentWeaponHash, hash)
                    end
                end
            end
        end
        -- fill currently equipped weapon with mag.currentCapacity (or +1 if not pistol)
        --SetPedAmmo(myped, currentWeaponHash, ammoCountToUse)
        SetAmmoInClip(myped, currentWeaponHash, ammoCountToUse)
        if isFullAuto(currentWeaponHash) then
            SetPedAmmo(myped, currentWeaponHash, ammoCountToUse + 1) -- give pseudo ammo so we don't auto store weapon
        end
        -- reset state var
        ranOutOfAmmo = false
    end
end)

RegisterNetEvent("ammo:setRanOutOfAmmo")
AddEventHandler("ammo:setRanOutOfAmmo", function(status)
	ranOutOfAmmo = status
end)

-- save ammo after shooting
Citizen.CreateThread(function()
    while true do
        local myped = PlayerPedId()
        if IsPedShooting(myped) then
            Wait(50)
            if not IsPedShooting(myped) then
                local w = GetSelectedPedWeapon(myped)
                local b1, wa = GetAmmoInClip(myped, w)
                if ranOutOfAmmo then
                    wa = 0
                end
                TriggerServerEvent("ammo:save", wa)
            end
        end
        Wait(1)
    end
end)

-- reset equipped index char variable when weapon stored
Citizen.CreateThread(function()
    while true do
        local myped = PlayerPedId()
        local wasJustArmed = false
        local b1, wa = nil
        while GetSelectedPedWeapon(myped) ~= `WEAPON_UNARMED` do
            local w = GetSelectedPedWeapon(myped)
            b1, wa = GetAmmoInClip(myped, w)
            --local wa = GetAmmoInPedWeapon(myped, w)
            wasJustArmed = true
            Wait(1)
        end
        if wasJustArmed then
            if ranOutOfAmmo then
                wa = 0
            end
            TriggerServerEvent("ammo:weaponStored", wa)
            ranOutOfAmmo = false
            wasJustArmed = false
            TriggerEvent("Weapons:Client:resetAlreadyTriggeredOutOfAmmo")
        end
        Wait(1)
    end
end)

-- disable shooting when out of ammo loop (since inferno-weapons resource puts a single bullet in the gun to prevent it from being auto stored by GTA when running out of ammo)
Citizen.CreateThread(function()
	while true do
		while ranOutOfAmmo do
            local p = PlayerPedId()

			-- disable firing
            local w = GetSelectedPedWeapon(p)

            if w == `WEAPON_UNARMED` then
                ranOutOfAmmo = false
                break
            end

            local b1, wa = GetAmmoInClip(p, w)

            if not (wa == 2 and isFullAuto(w)) then
                DisablePlayerFiring(PlayerId(), true)
            end

			-- Disable fire mode selector key
			DisableControlAction(0, FIREMODE_SELECTOR_KEY, true)

			-- Disable reload and pistol whip
			DisableControlAction(0, 45, true)
			DisableControlAction(0, 140, true)
			DisableControlAction(0, 141, true)
			DisableControlAction(0, 142, true)
			DisableControlAction(0, 257, true)
			DisableControlAction(0, 263, true)
			DisableControlAction(0, 264, true)
			Wait(0)
		end
        Wait(0)
	end
end)

-- remove weapon if holding right click to withdraw it when in a vehicle
Citizen.CreateThread(function()
    local wepWhenNotInVehicle = nil
    while true do
        local myped = PlayerPedId()
        if IsPedInAnyVehicle(myped, true) then
            Wait(500)
            if GetCurrentPedWeapon(myped, true) ~= `WEAPON_UNARMED` and wepWhenNotInVehicle == `WEAPON_UNARMED` then
                SetCurrentPedWeapon(myped, `WEAPON_UNARMED`, true)
            end
            wepWhenNotInVehicle = nil
        else
            wepWhenNotInVehicle = GetSelectedPedWeapon(myped)
        end
        Wait(1)
    end
end)

function isAShotgun(weaponHash)
    local SHOTGUN_HASHES = {
        [`WEAPON_PUMPSHOTGUN`] = true,
        [`WEAPON_PUMPSHOTGUN_MK2`] = true,
        [`WEAPON_SAWNOFFSHOTGUN`] = true,
        [`WEAPON_ASSAULTSHOTGUN`] = true,
        [`WEAPON_BULLPUPSHOTGUN`] = true,
        [`WEAPON_HEAVYSHOTGUN`] = true,
        [`WEAPON_DBSHOTGUN`] = true,
        [`WEAPON_AUTOSHOTGUN`] = true,
        [`WEAPON_COMBATSHOTGUN`] = true
    }
    return (SHOTGUN_HASHES[weaponHash] or false)
end

function isFullAuto(wep)
	for i = 1, #FULL_AUTO_WEPS do
		if GetHashKey(FULL_AUTO_WEPS[i]) == wep then
			return true
		end
	end
	return false
end

function playAnimation(dict, name, duration, flag, timerBarText)
    exports.globals:loadAnimDict(dict)
    Citizen.CreateThread(function()
        TriggerEvent("interaction:setBusy", true)
        local me = PlayerPedId()
        local startTime = GetGameTimer()
        while GetGameTimer() - startTime < duration do
            if timerBarText then
                exports.globals:DrawTimerBar(startTime, duration, 1.42, 1.475, timerBarText)
            end
            if not IsEntityPlayingAnim(me, dict, name, 3) then
                TriggerEvent("usa:playAnimation", dict, name, -8, 1, -1, flag, 0, 0, 0, 0)
            end
            Wait(1)
        end
        if not IsPedInAnyVehicle(me, true) then
            ClearPedTasksImmediately(me)
        else
            if IsEntityPlayingAnim(me, dict, name, 3) then
                StopAnimTask(me, dict, name, 1.0)
            end
            ClearPedTasks(me)
        end
        TriggerEvent("interaction:setBusy", false)
    end)
end