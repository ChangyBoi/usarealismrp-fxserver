--# by: minipunch
--# for USA REALISM RP

local KEY_E = 38

local me = nil
local mycoords = nil

local active_job = nil

-------------------------
-- Spawn job peds --
-------------------------
local JOB_PEDS = {
  {x = -943.7, y = -2964.3, z = 13.9, heading = 110.0}, -- LSA
  --{x = 1724.6, y = 3283.5, z = 41.1, heading = 110.0} -- sandy shores airport
}

local RANDOM_CIV_MODELS = {
    -1249041111,
    1198698306,
    -2078561997,
    51789996,
    1459905209,
    -912318012,
    2120901815,
    664399832,
    -1697435671,
    920595805,
    -1932625649,
    71501447,
    -1057787465,
    -1176698112,
    -459818001,
    -1688898956,
    2010389054,
    1189322339,
    -775102410,
    793439294,
    -20018299
}

Citizen.CreateThread(function()
	for i = 1, #JOB_PEDS do
		local hash = -413447396 -- pilot

        if JOB_PEDS[i].hash then
            hash = JOB_PEDS[i].hash
        end

		--local hash = GetHashKey(data.ped.model)
		RequestModel(hash)
		while not HasModelLoaded(hash) do
			Wait(100)
		end

		local ped = CreatePed(4, hash, JOB_PEDS[i].x, JOB_PEDS[i].y, JOB_PEDS[i].z, JOB_PEDS[i].heading --[[Heading]], false --[[Networked, set to false if you just want to be visible by the one that spawned it]], true --[[Dynamic]])

        SetEntityCanBeDamaged(ped,false)
		SetPedCanRagdollFromPlayerImpact(ped,false)
		TaskSetBlockingOfNonTemporaryEvents(ped,true)
		SetPedFleeAttributes(ped,0,0)
		SetPedCombatAttributes(ped,17,1)
		SetPedRandomComponentVariation(ped, true)
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_HANG_OUT_STREET", 0, true);

	end
end)

---------------------------
-- Starting a mission --
---------------------------
Citizen.CreateThread(function()
    while true do
        me = GetPlayerPed(-1)
        mycoords = GetEntityCoords(me)
        for i  = 1, #JOB_PEDS do
            if Vdist(mycoords.x, mycoords.y, mycoords.z, JOB_PEDS[i].x, JOB_PEDS[i].y, JOB_PEDS[i].z) < 50.0 and not active_job then
                DrawGroundMarker(JOB_PEDS[i])
                if Vdist(mycoords.x, mycoords.y, mycoords.z, JOB_PEDS[i].x, JOB_PEDS[i].y, JOB_PEDS[i].z) < 2.0 then
                    drawTxt("Press [~y~E~w~] to start working for Air San Andreas!",7,1,0.5,0.8,0.5,255,255,255,255)
                    if IsControlJustPressed(1, KEY_E) then
                        --print("Starting job for Air San Andreas!")
                        TriggerServerEvent("pilotjob:newJob")
                    end
                end
            end
        end
        Wait(0)
    end
end)

----------------------------
-- Active Job Events --
----------------------------
Citizen.CreateThread(function()
    while true do
        if active_job then
            ----------------------------------------
            -- draw markers for active jobs --
            ----------------------------------------
            if active_job and active_job.current_marker then
                DrawGroundMarker(active_job.current_marker)
                if Vdist(mycoords.x, mycoords.y, mycoords.z, active_job.current_marker.x ,active_job.current_marker.y, active_job.current_marker.z) < 8.0 then
                    MarkCurrentCheckpointComplete()
                    GetNextCheckpoint()
                end
            end
            ---------------------------------------
            -- watch for job ending events --
            ---------------------------------------
            -- vehicle problems --
            if active_job and active_job.current_vehicle then
                local vehCoords = GetEntityCoords(active_job.current_vehicle)
                local dist = Vdist(mycoords.x, mycoords.y, mycoords.z, vehCoords.x, vehCoords.y, vehCoords.z)
                if not DoesEntityExist(active_job.current_vehicle) or GetVehicleEngineHealth(active_job.current_vehicle) <= 0 then
                    MarkCurrentCheckpointComplete() -- should mark all checkpoints completed?
                    active_job = nil
                    exports.globals:notify("Job ended! You damaged the aircraft!")
                    TriggerServerEvent("usa:loadPlayerComponents")
                elseif dist >= 700.0 then
                    MarkCurrentCheckpointComplete() -- should mark all checkpoints completed?
                    active_job = nil
                    TriggerServerEvent("pilotjob:endJob")
                    exports.globals:notify("Job ended! You went too far!")
                    TriggerServerEvent("usa:loadPlayerComponents")
                end
            end
            -- time --
            if active_job and active_job.start_time then
                if GetGameTimer() - active_job.start_time > 1000 * 60 * 60 then
                    MarkCurrentCheckpointComplete()
                    active_job = nil
                    exports.globals:notify("Job ended! Time expired!")
                    TriggerServerEvent("usa:loadPlayerComponents")
                end
            end
            -- player injury --
            if IsPedDeadOrDying(me) then
                MarkCurrentCheckpointComplete()
                active_job = nil
                exports.globals:notify("Job ended!")
                TriggerServerEvent("usa:loadPlayerComponents")
            end
            -- ped injury --
            if active_job and active_job.current_passengers then
                for i = 1, #active_job.current_passengers do
                    if IsPedDeadOrDying(active_job.current_passengers[i]) then
                        MarkCurrentCheckpointComplete()
                        active_job = nil
                        TriggerServerEvent("usa:loadPlayerComponents")
                        exports.globals:notify("Job ended! A passenger was injured!")
                        break
                    end
                end
            end
        end
        Wait(0)
    end
end)

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function DrawGroundMarker(location)
  DrawMarker(27, location.x, location.y, location.z - 0.75, 0, 0, 0, 0, 0, 0, 2.0, 2.0, 1.0, 240, 230, 140, 90, 0, 0, 2, 0, 0, 0, 0)
end

RegisterNetEvent("pilotjob:playSound")
AddEventHandler("pilotjob:playSound", function(sound)
    PlaySoundFrontend(-1, sound.name, sound.soundset, true)
end)

RegisterNetEvent("pilotjob:beginJob")
AddEventHandler("pilotjob:beginJob", function(job)
    active_job = job
    active_job.start_time = GetGameTimer()
    ------------------------
    -- Spawn Aircraft --
    ------------------------
    if job.plane_spawn then
        SpawnPlane(job.plane_spawn)
    end
    --------------------------
    -- Set First Aircraft  --
    --------------------------
    GetNextCheckpoint()
    -- Set Job Clothing --
    SetJobClothing()
end)

function SetJobClothing()
    --ClearPedProp(me, 0)
    if IsPedModel(me,"mp_f_freemode_01") then
        SetPedComponentVariation(me, 3, 7, 0, 0) -- arms/hands
        SetPedComponentVariation(me, 11, 10, 0, 2) -- torso
        SetPedComponentVariation(me, 8, 5, 0, 2) -- accessories
        SetPedComponentVariation(me, 9, 0, 0, 2) -- remove vest
        SetPedComponentVariation(me, 7, 34,1, 2) -- ties
        SetPedComponentVariation(me, 4, 6, 1, 2) -- legs
        SetPedComponentVariation(me, 6, 58, 1, 2) -- feet
        --SetPedPropIndex(me, 0, 1, math.random(1, 7), true) -- add headet on head (need to find right prop)
    elseif IsPedModel(me,"mp_m_freemode_01") then -- male
          SetPedComponentVariation(me, 3, 6, 0, 0) -- arms/hands
          SetPedComponentVariation(me, 11, 10, 1, 2) -- torso
          SetPedComponentVariation(me, 8, 21, 4, 2) -- accessories
          SetPedComponentVariation(me, 9, 0, 0, 2) -- remove vest
          SetPedComponentVariation(me, 7, 21,11, 2) -- ties
          SetPedComponentVariation(me, 4, 10, 1, 2) -- legs
          SetPedComponentVariation(me, 6, 10, 0, 0) -- feet
          --SetPedPropIndex(me, 0, 0, math.random(1, 7), true) -- add headet on head(need to find right prop)
    end
    -- remove weird black box on back/front? --
    SetPedComponentVariation(me, 10, 0, 0, 0)
end

function SpawnPlane(plane)
    Citizen.CreateThread(function()
        local numberHash = GetHashKey(plane.model)
        -- Request the model so that it can be spawned
        RequestModel(numberHash)
        -- Check if it's loaded, if not then wait and re-request it.
        while not HasModelLoaded(numberHash) do
            Citizen.Wait(100)
        end
        -- Model loaded, continue
        local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
        -- Spawn the vehicle at the gas station car dealership in paleto and assign the vehicle handle to 'vehicle'
        active_job.current_vehicle = CreateVehicle(numberHash, plane.location.x, plane.location.y, plane.location.z, 56.0 --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
        SetVehicleExplodesOnHighExplosionDamage(active_job.current_vehicle, false)
        SetEntityAsMissionEntity(active_job.current_vehicle, true, true)
        local curVehPlate = exports.globals:trim(GetVehicleNumberPlateText(active_job.current_vehicle))
        TriggerServerEvent("fuel:setFuelAmount", curVehPlate, 100)
        local key = {
    			name = "Key -- " .. curVehPlate,
    			quantity = 1,
    			type = "key",
    			owner = "San Andreas Air",
    			make = "Air",
    			model = "Craft",
    			plate = curVehPlate
    		}
    		-- give key to owner
    		TriggerServerEvent("garage:giveKey", key)
        -- spawn any peds if required --
        if plane.passengers then
            if not active_job.current_passengers then
                active_job.current_passengers = {}
            end
            -- first insert co pilot --
            local copilot_hash = -413447396
            RequestModel(copilot_hash)
            while not HasModelLoaded(copilot_hash) do
                Wait(100)
            end
            local copilot = CreatePed(4, copilot_hash, plane.location.x + 5.0, plane.location.y + 3.0, plane.location.z, 0.0 --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
            table.insert(active_job.current_passengers, copilot)
            if IsVehicleSeatFree(active_job.current_vehicle, 0) then
                TaskWarpPedIntoVehicle(copilot, active_job.current_vehicle, 0)
            end
            -- then insert rest of peds, either random or specified in sv file --
            if type(plane.passengers) == "table" then
                for i = 1, #plane.passengers do
                    local passenger = plane.passengers[i]
                    local model = passenger.model
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Citizen.Wait(100)
                    end
                    if IsVehicleSeatFree(active_job.current_vehicle, i) then
                      local ped = CreatePed(4, model, plane.location.x + 5.0, plane.location.y + 3.0, plane.location.z, 0.0 --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
                      table.insert(active_job.current_passengers, ped)
                      TaskWarpPedIntoVehicle(ped, active_job.current_vehicle, i)
                    end
                end
            elseif type(plane.passengers) == "number" then
                for i = 1, plane.passengers do
                    local model = RANDOM_CIV_MODELS[math.random(#RANDOM_CIV_MODELS)]
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                        Citizen.Wait(100)
                    end
                    local ped = CreatePed(4, model, plane.location.x + 5.0, plane.location.y + 3.0, plane.location.z, 0.0 --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
                    if not active_job.current_passengers then
                        active_job.current_passengers = {}
                    end
                    table.insert(active_job.current_passengers, ped)
                    if IsVehicleSeatFree(active_job.current_vehicle, i) then
                        TaskWarpPedIntoVehicle(ped, active_job.current_vehicle, i)
                    end
                end
            end
            --print("creating and adding passengers!")
        end
    end)
end

function GetNextCheckpoint()
    for i = 1, #active_job.checkpoints do
        local checkpoint = active_job.checkpoints[i]
        if not checkpoint.completed then
            -- Create Blip --
            active_job.blip = AddBlipForCoord(checkpoint.coords.x, checkpoint.coords.y, checkpoint.coords.z)
            SetBlipSprite(active_job.blip, 1)
            SetBlipDisplay(active_job.blip, 4)
    		    SetBlipScale(active_job.blip, 0.9)
            SetBlipColour(active_job.blip, 61)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Mission Checkpoint")
            EndTextCommandSetBlipName(active_job.blip)
            -- Create Marker --
            active_job.current_marker = checkpoint.coords
            -- Send Mission Help Text --
            exports["globals"]:notify(checkpoint.requirement)
            TriggerEvent('chatMessage', "", {0, 0, 0}, "^2MISSION TASK: ^0" .. checkpoint.requirement)
            DrawSpecialTextTimed(checkpoint.requirement, 10)
            return
        end
    end
    --print("All checkpoints completed!")
    local givemoney = true
    if active_job.current_vehicle then
        local vehcoords = GetEntityCoords(active_job.current_vehicle)
        if Vdist(mycoords.x, mycoords.y, mycoords.z, vehcoords.x, vehcoords.y, vehcoords.z) > 550.0 then
            givemoney = false
        end
        TriggerEvent('persistent-vehicles/forget-vehicle', active_job.current_vehicle)
        DeleteVehicle(active_job.current_vehicle)
    end
    if active_job.current_passengers then
        for i = 1, #active_job.current_passengers do
            DeleteEntity(active_job.current_passengers[i])
        end
    end
    while securityToken == nil do
        Wait(1)
    end
    TriggerServerEvent("pilotjob:jobComplete", active_job, givemoney, securityToken)
    active_job = nil
    -- Remove job clothing --
    TriggerServerEvent("usa:loadPlayerComponents")
end

function MarkCurrentCheckpointComplete()
    for i = 1, #active_job.checkpoints do
        local checkpoint = active_job.checkpoints[i]
        if not checkpoint.completed then
            -- check for passengers to exit --
            if checkpoint.passengers_exit then
                if active_job.current_passengers then
                    for i = #active_job.current_passengers, 1, -1 do
                        TaskLeaveVehicle(active_job.current_passengers[i], active_job.current_vehicle, 1)
                        Wait(1000)
                        TaskWanderStandard(active_job.current_passengers[i], 10.0, 10)
                        Wait(1000)
                        SetPedAsNoLongerNeeded(active_job.current_passengers[i])
                        table.remove(active_job.current_passengers, i)
                    end
                end
            end
            -- check for cargo to drop off --
            if checkpoint.cargo_drop then
                --Citizen.CreateThread(function()
                    SetVehicleEngineOn(active_job.current_vehicle, false, false, false)
                    local start = GetGameTimer()
                    local waittime = 20
                    while GetGameTimer() - start < waittime * 1000 do
                        drawTxt("Dropping off cargo: " .. math.ceil(((waittime * 1000) - (GetGameTimer() - start)) / 1000)  .. " second(s)",7,1,0.5,0.8,0.5,255,255,255,255)
                        if IsVehicleEngineOn(active_job.current_vehicle) then
                            SetVehicleEngineOn(active_job.current_vehicle, false, false, false)
                        end
                        Wait(0)
                    end
                    SetVehicleEngineOn(active_job.current_vehicle, true, false, false)
                --end)
            end
            active_job.checkpoints[i].completed = true
            if active_job.blip then
                RemoveBlip(active_job.blip)
            end
            active_job.blip = nil
            active_job.current_marker = nil
            -- play sound --
            PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", true)
            -- play take off interactSound sound if on second checkpoint (runway takeoff hopefully) --
            if checkpoint.sound  then
                --print("playing ATC3.ogg!")
                TriggerServerEvent("InteractSound_SV:PlayOnSource", checkpoint.sound, 0.3)
            end
            return
        end
    end
end

function DrawSpecialText(m_text)
    ClearPrints()
	SetTextEntry_2("STRING")
	AddTextComponentString(m_text)
	DrawSubtitleTimed(250, 1)
end

-- time should be sent in seconds
function DrawSpecialTextTimed(text, time)
    Citizen.CreateThread(function()
        time = time * 1000
        local start = GetGameTimer()
        while GetGameTimer() - start < time do
            DrawSpecialText(text)
            Wait(0)
        end
    end)
end

function DeleteVehicle(entity)
	Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end
