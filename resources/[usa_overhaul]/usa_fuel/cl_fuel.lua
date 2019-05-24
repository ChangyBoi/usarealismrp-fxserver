local playerPed
local playerVeh
local interactionKey = 38

local fuelStations = {
	['Aircraft'] = {
		price = 25,
		locations = {
			{-1007.71, -3015.91, 14.94},
			{-1229.56, -2877.206, 15.94},
			{2103.68, 4787.89, 42.21},
			{1699.52, 3271.27, 42.13},
			{1769.85, 3239.59, 43.12},
			{449.48, -981.07, 44.69}, -- MISSION ROW
			{351.42, -588.21, 75.16} -- PILLBOX MEDICAL 
		}
	},
	['Watercraft'] = {
		price = 10,
		locations = {
			{7.10, -2775.74, 1.85},
			{1327.06, 4217.90, 33.60},
			{-487.81, 6491.39, 1.40},
			{-802.50, -1504.67, 2.35}
		}
	},
	['Gasoline'] = {
		price = 5,
		locations = {
			{-94.136, 6419.508, 32.48}, -- Paleto Blvd.
			{179.96, 6602.94, 32.86}, -- Paleto Bay, LSC.
			{1702.92, 6415.82, 33.76}, -- Paleto Bay, 24/7 Store
			{1687.17, 4929.64, 43.07}, -- Grapeseed, LTD Store
			{2005.161, 3774.207, 33.40}, -- Sandy Shores, 24/7 Store
			{2680.207, 3264.007, 56.24}, -- Senora Fwy, 24/7 Store
			{1039.08, 2671.26, 40.55}, -- Route 68, Motel
			{49.71, 2779.207, 59.04}, -- Harmony, Route 68
			{-2554.91, 2334.65, 34.07}, -- Zancudo, Route 68
			{2581.49, 361.78, 109.46}, -- Los Santos Fwy
			{620.88, 268.87, 104.08}, -- Downtown Vinewood
			{-1798.91, 802.53, 139.65}, -- Richman Glen
			{-2096.703, -321.65, 14.16}, -- Del Perro Fwy
			{-1437.31, -276.24, 47.20}, -- Morningwood
			{1181.87, -330.27, 70.31}, -- Mirror Park, LTD Store
			{-724.74, -934.66, 20.21}, -- Lindsay Circus, Ginger St.
			{-526.28, -1210.95, 19.18}, -- Calais Ave, Innocence Blvd.
			{264.93, -1262.58, 30.29}, -- Stawberry Ave, Olympic Fwy
			{-70.44, -1760.49, 30.53}, -- Grove St., LTD Store
			{1208.34, -1402.18, 36.22}, -- Capital Blvd, El Rancho Blvd.
			{819.09, -1029.48, 27.404} -- Popular St, Olympic Fwy
		}
	}
}

local fuelData = {
	fuelAmount = 50,
	fuelUsage = 0.0,
	lastVeh = nil,
	isRefuelling = false,
	displayFuel = true
}

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Fuel Station", "~b~Welcome!", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

function createGasolineMenu(vehicleType)
	local amountToRefuel 
	local litersToRefuel = {}
	for i = 1, 100 - (math.floor(fuelData.fuelAmount)) do
		table.insert(litersToRefuel, i)
	end
	local amountItem = UIMenuListItem.New('Gallons', litersToRefuel, 'Amount of fuel to purchase')
	mainMenu:AddItem(amountItem)
	mainMenu.OnListChange = function(sender, item, index)
		if item == amountItem then
			amountToRefuel = item:IndexToItem(index)
		end
	end
	local purchaseItem = NativeUI.CreateItem('Purchase Fuel', '')
	mainMenu:AddItem(purchaseItem)
	purchaseItem.Activated = function(parentmenu, selected)
		if not GetIsVehicleEngineRunning(playerVeh) then
			TriggerServerEvent('fuel:purchaseFuel', amountToRefuel, vehicleType)
			mainMenu:Visible(false)
		else
			TriggerEvent('usa:notify', '~y~Vehicle engine must be off!')
		end
	end
end

-- Main thread for displaying fuel, managing menu and updating global variables
Citizen.CreateThread(function()
	local wasInVeh = false
	while true do
		Citizen.Wait(0)
		playerPed = PlayerPedId()
		playerVeh = GetVehiclePedIsIn(playerPed, true)
		_menuPool:MouseControlsEnabled(false)
		_menuPool:ControlDisablingEnabled(false)
		_menuPool:ProcessMenus()
		for k, v in pairs(fuelStations) do
			for i = 1, #fuelStations[k].locations do
				local x, y, z = table.unpack(fuelStations[k].locations[i])
				if Vdist(GetEntityCoords(playerPed), x, y, z) < 12.0 then
					DrawText3D(x, y, z, '[E] - Fuel Station')
				end
			end
		end
		if mainMenu:Visible() and not IsNearFuelStation(GetVehicleType(playerVeh)) then
			mainMenu:Visible(false)
		end
		if IsControlJustPressed(0, interactionKey) then
			if IsNearFuelStation(GetVehicleType(playerVeh)) and GetPedInVehicleSeat(playerVeh, -1) == playerPed then
				if fuelData.fuelAmount < 100 and GetVehicleType(playerVeh) ~= 'Blacklisted' and not fuelData.isRefuelling then
					mainMenu:Clear()
					createGasolineMenu(GetVehicleType(playerVeh))
					mainMenu:Visible(not mainMenu:Visible())
				else
					TriggerEvent('usa:notify', '~y~This vehicle cannot be refuelled!')
				end
			end
		end
		if fuelData.displayFuel then
			if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(playerVeh, -1) == playerPed and GetVehicleClass(playerVeh) ~= 13 and GetVehicleClass(playerVeh) ~= 21 then
				if not wasInVeh then
					TriggerServerEvent('fuel:returnFuelAmount', GetVehicleNumberPlateText(playerVeh))
					wasInVeh = true
				end
				DrawTxt(0.708, 1.418, 1.0, 1.0, 0.55, math.floor(fuelData.fuelAmount) .. '', 255, 255, 255, 255)
				DrawTxt(0.729, 1.425, 1.0, 1.0, 0.35, 'Fuel', 255, 255, 255, 255)
			else
				if wasInVeh then
					wasInVeh = false
				end
			end
		end
	end
end)

-- Fuel amount decreases over time, set vehicle is undrivable is no fuel left
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if IsPedInAnyVehicle(playerPed, -1) and GetPedInVehicleSeat(playerVeh, -1) == playerPed and GetVehicleType(playerVeh) ~= 'Blacklisted' then
			local vehicleSpeed = math.ceil(GetEntitySpeed(playerVeh) * 2.236936)
			if vehicleSpeed > 1 and vehicleSpeed < 20 then
				fuelData.fuelUsage = 0.0025
			elseif vehicleSpeed >= 20 and vehicleSpeed < 50 then
				fuelData.fuelUsage = 0.0050
			elseif vehicleSpeed >= 50 and vehicleSpeed < 80 then
				fuelData.fuelUsage = 0.0075
			elseif vehicleSpeed >= 80 and vehicleSpeed < 100 then
				fuelData.fuelUsage = 0.0500
			elseif vehicleSpeed >= 100 and vehicleSpeed < 130 then
				fuelData.fuelUsage = 0.1000
			elseif vehicleSpeed >= 130 then
				fuelData.fuelUsage = 0.2500
			elseif vehicleSpeed >= 150 then
				fuelData.fuelUsage = 0.5000
			elseif vehicleSpeed >= 180 then
				fuelData.fuelUsage = 1.0000
			else
				fuelData.fuelUsage = 0
			end

			if fuelData.fuelAmount - fuelData.fuelUsage > 0 then
				fuelData.fuelAmount = fuelData.fuelAmount - fuelData.fuelUsage
			else
				fuelData.fuelAmount = 0
				SetVehicleUndriveable(playerVeh, true)
			end
		end
	end
end)

-- Update fuel amount of vehicle in server script every 15 seconds
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		if IsPedInAnyVehicle(playerPed, -1) and GetPedInVehicleSeat(playerVeh, -1) == playerPed then
			TriggerServerEvent('fuel:setFuelAmount', GetVehicleNumberPlateText(playerVeh), fuelData.fuelAmount)
			Citizen.Wait(5000)
		end
	end
end)

AddEventHandler('usa:toggleImmersion', function(toggleOn)
	fuelData.displayFuel = toggleOn
end)

RegisterNetEvent('fuel:updateFuelAmount')
AddEventHandler('fuel:updateFuelAmount', function(_fuelAmount)
	fuelData.fuelAmount = _fuelAmount
end)

RegisterNetEvent('fuel:refuelAmount')
AddEventHandler('fuel:refuelAmount', function(_fuelAmount)
	local startTime = GetGameTimer()
	local timeWaiting = 500 * _fuelAmount
	Citizen.CreateThread(function()
		while _fuelAmount > 0 do
			Citizen.Wait(0)
			DisableControlAction(0, 75, true)
			SetVehicleEngineOn(playerVeh, false, true, false)
			DrawTimer(startTime, timeWaiting, 1.42, 1.475, 'REFUELING')
		end
	end)

	fuelData.isRefuelling = true
	while _fuelAmount > 0 do
		Citizen.Wait(500)
		if fuelData.fuelAmount == 100 then
			break
		else
			_fuelAmount = _fuelAmount - 1
			fuelData.fuelAmount = fuelData.fuelAmount + 1
		end
	end
	fuelData.isRefuelling = false
end)

function DrawTimer(beginTime, duration, x, y, text)
    if not HasStreamedTextureDictLoaded('timerbars') then
        RequestStreamedTextureDict('timerbars')
        while not HasStreamedTextureDictLoaded('timerbars') do
            Citizen.Wait(0)
        end
    end

    if GetTimeDifference(GetGameTimer(), beginTime) < duration then
        w = (GetTimeDifference(GetGameTimer(), beginTime) * (0.085 / duration))
    end

    local correction = ((1.0 - math.floor(GetSafeZoneSize(), 2)) * 100) * 0.005
    x, y = x - correction, y - correction

    Set_2dLayer(0)
    DrawSprite('timerbars', 'all_black_bg', x, y, 0.15, 0.0325, 0.0, 255, 255, 255, 180)

    Set_2dLayer(1)
    DrawRect(x + 0.0275, y, 0.085, 0.0125, 100, 0, 0, 180)

    Set_2dLayer(2)
    DrawRect(x - 0.015 + (w / 2), y, w, 0.0125, 150, 0, 0, 180)

    SetTextColour(255, 255, 255, 180)
    SetTextFont(0)
    SetTextScale(0.3, 0.3)
    SetTextCentre(true)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    Set_2dLayer(3)
    DrawText(x - 0.06, y - 0.012)
end

function DrawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(6)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function DrawText3D(x, y, z, text)
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

function GetVehicleType(vehicle)
	local vehicleName = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle))

	for _, k in pairs(blacklisted_models) do
		if k == vehicleName then
			return 'Blacklisted'
		end
	end

	if GetVehicleClass(vehicle) == 16 or GetVehicleClass(vehicle) == 15 then
		return 'Aircraft'
	elseif GetVehicleClass(vehicle) == 14 then
		return 'Watercraft'
	end

	--[[for _, k in pairs(electric_models) do
		if k == vehicleName then
			return 'Electric'
		end
	end]]

	return 'Gasoline'
end


function IsNearFuelStation(stationType)
	for k, v in pairs(fuelStations) do
		if k == stationType then
			for i = 1, #fuelStations[k].locations do
				local x, y, z = table.unpack(fuelStations[k].locations[i])
				if Vdist(GetEntityCoords(playerPed), x, y, z) < 8.0 then
					return true
				end
			end
		end
	end
	return false
end



----------------------
---- Set up blips ----
----------------------

local BLIPS = {}
function EnumerateBlips(type)
	if type == 'Gasoline' then
		for i = 1, #fuelStations['Gasoline'].locations do
			local x, y, z = table.unpack(fuelStations['Gasoline'].locations[i])
	      	local blip = AddBlipForCoord(x, y, z)
	      	local blipItem = {
				handle = blip,
				type = 'Gasoline'
			}
	        SetBlipSprite(blip, 361)
	        SetBlipDisplay(blip, 3)
	        SetBlipScale(blip, 0.5)
	        SetBlipAsShortRange(blip, true)
	        BeginTextCommandSetBlipName("STRING")
	        AddTextComponentString('Fuel Station')
	        EndTextCommandSetBlipName(blip)
	        table.insert(BLIPS, blipItem)
	    end
	elseif type == 'Watercraft' then
	    for i = 1, #fuelStations['Watercraft'].locations do
			local x, y, z = table.unpack(fuelStations['Watercraft'].locations[i])
	      	local blip = AddBlipForCoord(x, y, z)
	      	local blipItem = {
				handle = blip,
				type = 'Watercraft'
			}
	        SetBlipSprite(blip, 361)
	        SetBlipDisplay(blip, 3)
	        SetBlipScale(blip, 0.5)
	        SetBlipColour(blip, 21)
	        SetBlipAsShortRange(blip, true)
	        BeginTextCommandSetBlipName("STRING")
	        AddTextComponentString('Watercraft Fuel')
	        EndTextCommandSetBlipName(blip)
	        table.insert(BLIPS, blipItem)
	    end
	elseif type == 'Aircraft' then
	    for i = 1, #fuelStations['Aircraft'].locations do
			local x, y, z = table.unpack(fuelStations['Aircraft'].locations[i])
			if x ~= 449.48 and x ~= 351.42 then
		      	local blip = AddBlipForCoord(x, y, z)
		      	local blipItem = {
					handle = blip,
					type = 'Aircraft'
				}
		        SetBlipSprite(blip, 361)
		        SetBlipDisplay(blip, 3)
		        SetBlipScale(blip, 0.5)
		        SetBlipColour(blip, 21)
		        SetBlipAsShortRange(blip, true)
		        BeginTextCommandSetBlipName("STRING")
		        AddTextComponentString('Aircraft Fuel')
		        EndTextCommandSetBlipName(blip)
		        table.insert(BLIPS, blipItem)
		    end
	    end
	end
end

TriggerServerEvent('blips:getBlips')

RegisterNetEvent('blips:returnBlips')
AddEventHandler('blips:returnBlips', function(blipsTable)
  if blipsTable['fuel'] then
    EnumerateBlips('Gasoline')
  else
  	for i = 1, #BLIPS do
  		if BLIPS[i].type == 'Gasoline' then
      		RemoveBlip(BLIPS[i].handle)
      		table.remove(BLIPS, i)
      	end
    end
  end
  -----------------------------------------------
  if blipsTable['planefuel'] then
  	EnumerateBlips('Aircraft')
  else
  	for i = 1, #BLIPS do
  		if BLIPS[i].type == 'Aircraft' then
      		RemoveBlip(BLIPS[i].handle)
      		table.remove(BLIPS, i)
      	end
    end
  end
  -----------------------------------------------
  if blipsTable['boatfuel'] then
  	EnumerateBlips('Watercraft')
  else
  	for i = 1, #BLIPS do
  		if BLIPS[i].type == 'Watercraft' then
      		RemoveBlip(BLIPS[i].handle)
      		table.remove(BLIPS, i)
      	end
    end
  end
end)

-----------------
-----------------
-----------------
