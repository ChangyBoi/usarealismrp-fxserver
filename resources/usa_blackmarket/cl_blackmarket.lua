local MENU_KEY = 38 -- "E"
local closest_shop = nil
local openingHour = nil
local closingHour = nil

local markets = {}

TriggerServerEvent("blackMarket:loadItems")
TriggerServerEvent("blackMarket:openAndClosingHours")

RegisterNetEvent("blackMarket:loadItems")
AddEventHandler("blackMarket:loadItems", function(items)
  markets = items
end)

RegisterNetEvent("blackMarket:operatingHours")
AddEventHandler("blackMarket:operatingHours", function(open, closed)
    openingHour = open
    closingHour = closed
end)


local createdJobPeds = {}
Citizen.CreateThread(function()
  while true do
    local playerCoords = GetEntityCoords(PlayerPedId(), false)
    for k, v in pairs(markets) do
      local mkt = markets[k]
      if Vdist(mkt['coords'][1], mkt['coords'][2], mkt['coords'][3], playerCoords.x, playerCoords.y, playerCoords.z) < 50 then
          if not createdJobPeds[k] then
              RequestModel(mkt['pedHash'])
              while not HasModelLoaded(mkt['pedHash']) do
                  Wait(100)
              end
              local ped = CreatePed(4, mkt['pedHash'], mkt['coords'][1], mkt['coords'][2], mkt['coords'][3] - 1.0, mkt['pedHeading'] or 100, false, true)
              SetEntityCanBeDamaged(ped,false)
              SetPedCanRagdollFromPlayerImpact(ped,false)
              SetBlockingOfNonTemporaryEvents(ped,true)
              SetPedFleeAttributes(ped,0,0)
              SetPedCombatAttributes(ped,17,1)
              SetPedRandomComponentVariation(ped, true)
              TaskStartScenarioInPlace(ped, (mkt['pedScenario'] or "WORLD_HUMAN_STAND_MOBILE"), 0, true)
              createdJobPeds[k] = ped
          end
      else 
        if createdJobPeds[k] then
          DeletePed(createdJobPeds[k])
          createdJobPeds[k] = nil
        end
      end
    end
    Wait(1)
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

----------------------
-- Set up main menu --
----------------------
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Black Market", "~b~What are you looking for?", 0 --[[X COORD]], 320 --[[Y COORD]])
_menuPool:Add(mainMenu)

RegisterNetEvent("blackMarket:equipWeapon")
AddEventHandler("blackMarket:equipWeapon", function(hash, name, equipNow)
	local playerPed = GetPlayerPed(-1)
	GiveWeaponToPed(playerPed, hash, 0, false, equipNow)
  if name == "Molotov" then
    SetPedAmmo(playerPed, hash, 1)
  end
end)

function CreateItemList(menu)
  ---------------------------------------------
  -- Button for each weapon in each category --
  ---------------------------------------------
    for k, v in pairs(markets) do
        local x, y, z = table.unpack(markets[k]['coords'])
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x, y, z, true) < 5 then
            for i = 1, #markets[k]['items'] do
                local item = NativeUI.CreateItem(markets[k]['items'][i].name, "Purchase price: $" .. comma_value(markets[k]['items'][i].price))
                item.Activated = function(parentmenu, selected)
                  TriggerServerEvent("blackMarket:requestPurchase", k, i)
                end
                menu:AddItem(item)
            end
        end
    end
end

function IsPlayerAtBlackMarket()
    local atblackmarket = false
    for k, v in pairs(markets) do
        local x, y, z = table.unpack(markets[k]['coords'])
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x, y, z, true) < 5 then
            closest_shop = k
            atblackmarket = true
        end
    end
    if atblackmarket then return true else return false end
end

function isOpen()
  local currentHour = GetClockHours()
  if currentHour >= openingHour and currentHour <= closingHour then
      return true
  else
      return false
  end
end

Citizen.CreateThread(function()
	while true do
    	Wait(0)
      -- Process Menu --
      _menuPool:MouseControlsEnabled(false)
      _menuPool:ControlDisablingEnabled(false)
      _menuPool:ProcessMenus()
      ------------------
      -- Draw Markers --
      ------------------
      for k, v in pairs(markets) do
        local x, y, z = table.unpack(markets[k]['coords'])
        DrawText3D(x, y, z, (markets[k]['3dTextDistance'] or 2), '[E] - Black Market')
      end
      --------------------------
      -- Listen for menu open --
      --------------------------
      if IsControlJustPressed(1, MENU_KEY) then
          if IsPlayerAtBlackMarket() then
              if isOpen() then
                  mainMenu:Clear()
                  CreateItemList(mainMenu)
                  mainMenu:Visible(not mainMenu:Visible())
              else
                  exports.globals:notify("My connect is still sleeping! Come back later!")
              end
          end
      end

      if mainMenu:Visible() then
          local playerPed = PlayerPedId()
          local playerCoords = GetEntityCoords(playerPed)
          local x, y, z = table.unpack(markets[closest_shop]['coords'])
          if Vdist(playerCoords, x, y, z) > 5.0 then
              mainMenu:Visible(false)
          end
      end
	end
end)

function DrawText3D(x, y, z, distance, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), x, y, z, true) < distance then
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
