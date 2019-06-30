local policeLockerRooms = {
	{x = -1107.5, y = -847.5, z = 19.4}, -- vespucci PD
	{x = 370.3, y = -1608.4, z = 28.3}, -- davis PD
	{x = 826.5, y = -1291.3, z = 27.3}, -- la mesa PD
	{x = 638.9, y = 1.9, z = 82.8}, -- vinewood PD, elgin ave.
	{x=454.475 , y=-990.79 , z=30.689},
 	{x=1850.97, y=3691.74, z=34.367}, -- sandy
 	--{x=-447.256 , y=6000.667 , z=30.686} -- paleto
 	{x = -449.471, y = 6010.7, z = 31.85}
}

local policeArmourys = {
	{x = -1109.6, y = -844.7, z = 19.4}, -- vespucci PD
	{x = 371.8, y = -1612.1, z = 28.4}, -- davis PD
	{x = 826.6, y = -1288.8, z = 28.2}, -- la mesa PD
	{x = 637.5, y = -2.7, z = 82.8}, -- vinewood PD, elgine ave.
	{x=452.964 , y=-980.095 , z=30.8896},
	{x=1851.34 , y=3683.64 , z=34.4671}, -- sandy
	--{x=-452.361 , y=6006.11 , z=30.8409} -- paleto
	{x = -447.9, y = 6008.7, z = 31.85}
}

local weapons = {}

local policeoutfitamount = {1, 2, 3, 4, 5}

local MAX_COMPONENT = 200
local MAX_COMPONENT_TEXTURE = 100
local MAX_PROP = 200
local MAX_PROP_TEXTURE = 100
local arrSkinGeneralCaptions = {"LSPD Male","LSPD Female","Motor Unit","SWAT","Sheriff Male","Sheriff Female","Traffic Warden","Custom Male","Custom Female","FBI 1","FBI 2","FBI 3","FBI 4","Detective Male","Detective Female","Ranger Male", "Ranger Female", "Tactical", "Pilot"}
local arrSkinGeneralValues = {"s_m_y_cop_01","s_f_y_cop_01","S_M_Y_HwayCop_01","S_M_Y_SWAT_01","S_M_Y_Sheriff_01","S_F_Y_Sheriff_01","ig_trafficwarden","mp_m_freemode_01","mp_f_freemode_01","mp_m_fibsec_01","ig_stevehains","ig_andreas","s_m_m_fiboffice_01","s_m_m_ciasec_01","ig_karen_daniels","S_M_Y_Ranger_01","S_F_Y_Ranger_01", "s_m_y_blackops_01", "s_m_m_pilot_02"}
local arrSkinHashes = {}
for i=1,#arrSkinGeneralValues do
	arrSkinHashes[i] = GetHashKey(arrSkinGeneralValues[i])
end
local components = {"Face","Head","Hair","Arms/Hands","Legs","Back","Feet","Ties","Shirt","Vests","Textures","Torso"}
local props = { "Head", "Glasses", "Ear Acessories", "Watch"}
local MENU_OPEN_KEY = 38
local closest_shop = nil

-- load armory items --
TriggerServerEvent("police:loadArmoryItems")

-- Events --
RegisterNetEvent("policestation2:setciv")
AddEventHandler("policestation2:setciv", function(character, playerWeapons)
	Citizen.CreateThread(function()
		local model
		if not character.hash then -- does not have any customizations saved
			model = -408329255 -- some random black dude with no shirt on, lawl
		else
			model = character.hash
		end
        RequestModel(model)
        while not HasModelLoaded(model) do -- Wait for model to load
            Wait(100)
        end
        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
		-- give model customizations if available
		if character.hash then
			for key, value in pairs(character["components"]) do
				--if tonumber(key) ~= 0 or tonumber(key) ~= 1 or tonumber(key) ~= 2 then -- emit barber shop features
					SetPedComponentVariation(GetPlayerPed(-1), tonumber(key), value, character["componentstexture"][key], 0)
				--end
			end
			for key, value in pairs(character["props"]) do
				SetPedPropIndex(GetPlayerPed(-1), tonumber(key), value, character["propstexture"][key], true)
			end
		end
		-- add any tattoos if they have any --
		if character.tattoos then
			--print("applying tattoos!")
			for i = 1, #character.tattoos do
				ApplyPedOverlay(GetPlayerPed(-1), GetHashKey(character.tattoos[i].category), GetHashKey(character.tattoos[i].hash_name))
			end
		else
			--print("no tattoos!!!")
		end
		-- add any barber shop customizations if any --
		if character.head_customizations then
			--print("barber shop customizations existed!")
			local head = character.head_customizations
			local ped = GetPlayerPed(-1)
			SetPedHeadBlendData(ped, head.parent1, head.parent2, head.parent3, head.skin1, head.skin2, head.skin3, head.mix1, head.mix2, head.mix3, false)
			-- facial stuff like beards and ageing and what not --
			for i = 1, #head.other do
				SetPedHeadOverlay(ped, i - 1, head.other[i][2], 1.0)
				if head.other[i][2] ~= 255 then
					if i == 2 or i == 3 or i == 11 then -- chest hair, facial hair, eyebrows
						SetPedHeadOverlayColor(ped, i - 1, 1, head.other[i][4])
					elseif i == 6 or i == 9 then -- blush, lipstick
						SetPedHeadOverlayColor(ped, i - 1, 2, head.other[i][4])
					elseif i == 14 then -- hair
						--print("setting head to: " .. head.other[i][2] .. ", color: " .. head.other[i][4])
						SetPedComponentVariation(ped, 2, head.other[i][2], 0, 1)
						SetPedHairColor(ped, head.other[i][4], head.other[i][5] or 0)
					end
				end
			end
		end
		-- give weapons
		if playerWeapons then
			for i = 1, #playerWeapons do
				GiveWeaponToPed(GetPlayerPed(-1), playerWeapons[i].hash, 1000, false, false)
				if playerWeapons[i].components then
			    if #playerWeapons[i].components > 0 then
			      for x = 1, #playerWeapons[i].components do
			        GiveWeaponComponentToPed(GetPlayerPed(-1), playerWeapons[i].hash, GetHashKey(playerWeapons[i].components[x]))
			      end
			    end
			  end
			  if playerWeapons[i].tint then
			    SetPedWeaponTintIndex(GetPlayerPed(-1), playerWeapons[i].hash, playerWeapons[i].tint)
			  end
			end
		end
    end)
end)

RegisterNetEvent("policestation2:isWhitelisted")
AddEventHandler("policestation2:isWhitelisted", function()
	CreateUniformMenu(mainMenu)
	mainMenu:Visible(true)
end)

RegisterNetEvent("policestation2:showArmoury")
AddEventHandler("policestation2:showArmoury", function()
	CreateArmoryMenu(mainMenu)
	mainMenu:Visible(true)
end)

RegisterNetEvent("policestation2:setCharacter")
AddEventHandler("policestation2:setCharacter", function(character)
	local ped = GetPlayerPed(-1)
	if character then
		for key, value in pairs(character["components"]) do
			SetPedComponentVariation(ped, tonumber(key), value, character["componentstexture"][key], 0)
		end
		for key, value in pairs(character["props"]) do
			SetPedPropIndex(ped, tonumber(key), value, character["propstexture"][key], true)
		end
		SetPedArmour(ped, 100)
	end
end)

RegisterNetEvent("police:loadArmoryItems")
AddEventHandler("police:loadArmoryItems", function(items)
	weapons = items
end)

-- Menu --
--// Main Menu
--//	Skin Selection (array)
--//  Components (submenu)
--//  Props (submenu)
--//  Load Default Uniform
--//  Save Default Uniform
--//  Off Duty

-----------------
-- Set up menu --
-----------------
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("SASP", "~b~San Andreas State Police", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

function CreateUniformMenu(menu)
	local ped = GetPlayerPed(-1)
	menu:Clear()

	local submenu2 = _menuPool:AddSubMenu(menu, "Outfits", "Save and load outfits", true)
	local selectedSaveSlot = 1
    local selectedLoadSlot = 1
    local saveslot = UIMenuListItem.New("Slot to Save", policeoutfitamount)
    local saveconfirm = UIMenuItem.New('Confirm Save', 'Save outfit into the above number')
    saveconfirm:SetRightBadge(BadgeStyle.Tick)
    local loadslot = UIMenuListItem.New("Slot to Load", policeoutfitamount)
    local loadconfirm = UIMenuItem.New('Load Outfit', 'Load outfit from above number')
    loadconfirm:SetRightBadge(BadgeStyle.Clothes)
    submenu2:AddItem(loadslot)
    submenu2:AddItem(loadconfirm)
    submenu2:AddItem(saveslot)
    submenu2:AddItem(saveconfirm)

    submenu2.OnListChange = function(sender, item, index)
        if item == saveslot then
            selectedSaveSlot = item:IndexToItem(index)
        elseif item == loadslot then
            selectedLoadSlot = item:IndexToItem(index)
        end
    end
    submenu2.OnItemSelect = function(sender, item, index)
        if item == saveconfirm then
            local character = {
			["components"] = {},
			["componentstexture"] = {},
			["props"] = {},
			["propstexture"] = {}
			}
			local ply = GetPlayerPed(-1)
			--local debugstr = "| Props: "
			for i=0,2 -- instead of 3?
				do
				character.props[i] = GetPedPropIndex(ply, i)
				character.propstexture[i] = GetPedPropTextureIndex(ply, i)
				--debugstr = debugstr .. character.props[i] .. "->" .. character.propstexture[i] .. ","
			end
			--debugstr = debugstr .. "| Components: "
			for i=0,11
				do
				character.components[i] = GetPedDrawableVariation(ply, i)
				character.componentstexture[i] = GetPedTextureVariation(ply, i)
				--debugstr = debugstr .. character.components[i] .. "->" .. character.componentstexture[i] .. ","
			end
			--print(debugstr)
			TriggerServerEvent("policestation2:saveOutfit", character, selectedSaveSlot)
        elseif item == loadconfirm then
            DoScreenFadeOut(500)
            Citizen.Wait(500)
            TriggerServerEvent('policestation2:loadOutfit', selectedLoadSlot)
			TriggerServerEvent('InteractSound_SV:PlayWithinDistance', 1, 'zip-close', 1.0)
			Citizen.Wait(2000)
			DoScreenFadeIn(500)
            TriggerEvent("usa:playAnimation", 'clothingshirt', 'try_shirt_positive_d', -8, 1, -1, 48, 0, 0, 0, 0, 3)
        end
    end
	-- Components --
	local submenu = _menuPool:AddSubMenu(menu, "Components", "Modify components", true --[[KEEP POSITION]])
	for i = 1, #components do
		local selectedComponent = GetPedDrawableVariation(ped, i - 1)
		local selectedTexture = GetPedTextureVariation(ped, i - 1)
		--local maxComponent = GetNumberOfPedDrawableVariations(ped, i - 1)
		--local maxTexture = GetNumberOfPedTextureVariations(ped, i - 1, selectedComponent)
		local arr = {}
		for j = 0, MAX_COMPONENT + 1 do arr[j] = j - 1 end
		local listitem = UIMenuListItem.New(components[i], arr, selectedComponent)
		listitem.OnListChanged = function(sender, item, index)
			if item == listitem then
				--print("Selected ~b~" .. index .. "~w~...")
				selectedComponent = index - 1
				SetPedComponentVariation(ped, i - 1, selectedComponent, 0, 0)
				selectedTexture = 0
			end
		end
		submenu:AddItem(listitem)
		--if maxTexture > 1 then
			arr = {}
			for j = 0, MAX_COMPONENT_TEXTURE + 1 do arr[j] = j - 1 end
			local listitem = UIMenuListItem.New(components[i] .. " Texture", arr, selectedTexture)
			listitem.OnListChanged = function(sender, item, index)
				if item == listitem then
					selectedTexture = index - 1
					SetPedComponentVariation(ped, i - 1, selectedComponent, selectedTexture, 0)
				end
			end
			submenu:AddItem(listitem)
		--end
	end
	-- Props --
	local submenu = _menuPool:AddSubMenu(menu, "Props", "Modify props", true --[[KEEP POSITION]])
	for i = 1, 3 do
		local selectedProp = GetPedPropIndex(ped, i - 1)
		local selectedPropTexture = GetPedPropTextureIndex(ped, i - 1)
		--local maxProp = GetNumberOfPedPropDrawableVariations(ped, i - 1)
		--local maxPropTexture = GetNumberOfPedPropTextureVariations(ped, i - 1, selectedProp)
		local arr = {}
		for j = 0, MAX_PROP + 1 do arr[j] = j - 1 end
		local listitem = UIMenuListItem.New(props[i], arr, selectedProp)
		listitem.OnListChanged = function(sender, item, index)
			if item == listitem then
				--print("Selected ~b~" .. index .. "~w~...")
				selectedProp = index - 1
				if selectedProp > -1 then
					SetPedPropIndex(ped, i - 1, selectedProp, 0, true)
				else
					ClearPedProp(ped, i - 1)
				end
			end
		end
		submenu:AddItem(listitem)
		-- add texture variation --
		--if maxPropTexture > 1 and selectedProp > -1 then
			arr = {}
			for j = 0, MAX_PROP_TEXTURE do arr[j] = j - 1 end
			local listitem = UIMenuListItem.New(props[i] .. " Texture", arr, selectedPropTexture)
			listitem.OnListChanged = function(sender, item, index)
				if item == listitem then
					--print("Selected ~b~" .. index .. "~w~...")
					selectedPropTexture = index - 1
					SetPedPropIndex(ped, i - 1, selectedProp, selectedPropTexture, true)
				end
			end
			submenu:AddItem(listitem)
		--end
	end
	local item = NativeUI.CreateItem("Clear Props", "Reset props.")
	item.Activated = function(parentmenu, selected)
		ClearPedProp(ped, 0)
		ClearPedProp(ped, 1)
		ClearPedProp(ped, 2)
	end
	submenu:AddItem(item)
	-- Clock Out --
	local item = NativeUI.CreateItem("Clock Out", "Sign off duty")
	item:SetRightBadge(BadgeStyle.Lock)
	item.Activated = function(parentmenu, selected)
		RemoveAllPedWeapons(ped)
		TriggerServerEvent("policestation2:offduty")
		TriggerEvent("interaction:setPlayersJob", "civ") -- set interaction menu javascript job variable to "civ"
		TriggerEvent("ptt:isEmergency", false)
	end
	menu:AddItem(item)
end

function CreateArmoryMenu(menu)
	local playerPed = PlayerPedId()
	menu:Clear()
	for i = 1, #weapons do
      local item = NativeUI.CreateItem(weapons[i].name, "Purchase price: $" .. comma_value(weapons[i].price))
      item.Activated = function(parentmenu, selected)
         TriggerServerEvent("policestation2:requestPurchase", i)
      end
      menu:AddItem(item)
    end
	--[[
    local item = NativeUI.CreateItem('Pump Shotgun (MK2)', 'Equip this weapon')
    item:SetRightBadge(BadgeStyle.Gun)
    item.Activated = function(parentmenu, selected)
    	GiveWeaponToPed(playerPed, 1432025498, 0, false, false)
    	SetPedAmmo(playerPed, 1432025498, 0)
    	GiveWeaponComponentToPed(playerPed, 1432025498, GetHashKey('COMPONENT_AT_SIGHTS'))
    	GiveWeaponComponentToPed(playerPed, 1432025498, GetHashKey('COMPONENT_AT_AR_FLSH'))
    	GiveWeaponComponentToPed(playerPed, 1432025498, GetHashKey('COMPONENT_PUMPSHOTGUN_MK2_CLIP_HOLLOWPOINT'))
    	Citizen.Wait(100)
    	local ammoType = GetPedAmmoTypeFromWeapon(playerPed, 1432025498)
    	SetPedAmmoByType(playerPed, ammoType, 16)
    	TriggerEvent('usa:notify', 'You have equipped a Pump Shotgun.')
    end
    menu:AddItem(item)
    local item = NativeUI.CreateItem('Carbine Rifle (MK2)', 'Equip this weapon')
    item:SetRightBadge(BadgeStyle.Gun)
    item.Activated = function(parentmenu, selected)
    	GiveWeaponToPed(playerPed, 4208062921, 0, false, false)
    	SetPedAmmo(playerPed, 4208062921, 0)
    	GiveWeaponComponentToPed(playerPed, 4208062921, GetHashKey('COMPONENT_AT_SIGHTS'))
    	GiveWeaponComponentToPed(playerPed, 4208062921, GetHashKey('COMPONENT_AT_AR_FLSH'))
    	GiveWeaponComponentToPed(playerPed, 4208062921, GetHashKey('COMPONENT_AT_AR_AFGRIP_02'))
    	GiveWeaponComponentToPed(playerPed, 4208062921, GetHashKey('COMPONENT_CARBINERIFLE_MK2_CLIP_FMJ'))
    	GiveWeaponComponentToPed(playerPed, 4208062921, GetHashKey('COMPONENT_AT_CR_BARREL_02'))
    	GiveWeaponComponentToPed(playerPed, 4208062921, GetHashKey('COMPONENT_AT_MUZZLE_06'))
    	Citizen.Wait(100)
    	local ammoType = GetPedAmmoTypeFromWeapon(playerPed, 4208062921)
    	SetPedAmmoByType(playerPed, ammoType, 40)
    	TriggerEvent('usa:notify', 'You have equipped a Carbine Rifle.')
    end
    menu:AddItem(item)
	--]]
    local item = NativeUI.CreateItem('Body Armor', 'Equip heavy-duty body armor')
    item:SetRightBadge(BadgeStyle.Armour)
    item.Activated = function(parentmenu, selected)
    	SetPedArmour(playerPed, 100)
    	TriggerEvent('usa:notify', 'Armor has been re-equipped.')
    end
    menu:AddItem(item)
    local item = NativeUI.CreateItem('Return Weapons', 'Return all non-purchased weapons')
    item:SetRightBadge(BadgeStyle.Tick)
    item.Activated = function(parentmenu, selected)
    	RemoveWeaponFromPed(playerPed, 1432025498)
    	RemoveWeaponFromPed(playerPed, 4208062921)
    	TriggerEvent('usa:notify', 'You have returned your weapons.')
    end
    menu:AddItem(item)
end

_menuPool:RefreshIndex()

-- Functions --
function DrawText3D(x, y, z, distance, text)
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x, y, z, true) < distance then
        local onScreen,_x,_y=World3dToScreen2d(x,y,z)
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
        local factor = (string.len(text)) / 370
        DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
    end
end
-- Script Loop --
Citizen.CreateThread(function()
	while true do
		Wait(0)
		local playerPed = PlayerPedId()
		local playerCoords = GetEntityCoords(playerPed, false)
		_menuPool:MouseControlsEnabled(false)
		_menuPool:ControlDisablingEnabled(false)
		_menuPool:ProcessMenus()
		for i = 1, #policeLockerRooms do
			DrawText3D(policeLockerRooms[i].x, policeLockerRooms[i].y, policeLockerRooms[i].z, 3.5, '[E] - Locker Room')
			DrawText3D(policeArmourys[i].x, policeArmourys[i].y, policeArmourys[i].z, 4, '[E] - Armory')
			if Vdist(playerCoords, policeLockerRooms[i].x, policeLockerRooms[i].y, policeLockerRooms[i].z)  <  2 then
				if IsControlJustPressed(1, MENU_OPEN_KEY) then
					closest_shop = policeLockerRooms[i] --// set shop player is at
					if not mainMenu:Visible() then
						TriggerServerEvent("policestation2:checkWhitelist", "policestation2:isWhitelisted")
					else
						mainMenu:Visible(false)
						mainMenu:Clear()
					end
				end
			elseif Vdist(playerCoords, policeArmourys[i].x, policeArmourys[i].y, policeArmourys[i].z)  <  2 then
				if IsControlJustPressed(1, MENU_OPEN_KEY) then
					closest_shop = policeArmourys[i] --// set shop player is at
					if not mainMenu:Visible() then
						TriggerServerEvent("policestation2:checkWhitelist", "policestation2:showArmoury")
					else
						mainMenu:Visible(false)
						mainMenu:Clear()
					end
				end
			else
				if closest_shop then
					closest_shop = nil
					if mainMenu:Visible() then
						mainMenu:Visible(false)
						mainMenu:Clear()
					end
				end
			end
		end
	end
end)

function comma_value(amount)
  local formatted = amount
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end
