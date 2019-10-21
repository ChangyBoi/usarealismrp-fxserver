local STORE_ITEMS = {
  ["Melee"] = {
    { name = "Flashlight", type = "weapon", hash = -1951375401, price = 200, legality = "legal", quantity = 1, weight = 9, objectModel = "p_cs_police_torch_s" },
    { name = "Hammer", type = "weapon", hash = 1317494643, price = 50, legality = "legal", quantity = 1, weight = 10, objectModel = "prop_tool_hammer" },
    { name = "Knife", type = "weapon", hash = -1716189206, price = 200, legality = "legal", quantity = 1, weight = 8, objectModel = "w_me_knife_01" },
    { name = "Bat", type = "weapon", hash = -1786099057, price = 100, legality = "legal", quantity = 1, weight = 20, objectModel = "w_me_bat" },
    { name = "Crowbar", type = "weapon", hash = -2067956739, price = 150, legality = "legal", quantity = 1, weight = 17, objectModel = "w_me_crowbar" },
    { name = "Hatchet", type = "weapon", hash = -102973651, price = 250, legality = "legal", quantity = 1, weight = 12, objectModel = "w_me_hatchet" },
    { name = "Wrench", type = "weapon", hash = 419712736, price = 400, legality = "legal", quantity = 1, weight = 12, objectModel = "prop_tool_wrench" },
    { name = "Machete", type = "weapon", hash = -581044007, price = 250, legality = "legal", quantity = 1, weight = 15, objectModel = "prop_ld_w_me_machette" }

  },
  ["Handguns"] = {
    { name = "Pistol", type = "weapon", hash = 453432689, price = 600, legality = "legal", quantity = 1, weight = 15, objectModel = "w_pi_pistol" },
    { name = "Heavy Pistol", type = "weapon", hash = -771403250, price = 1500, legality = "legal", quantity = 1, weight = 20, objectModel = "w_pi_heavypistol" },
    { name = ".50 Caliber", type = "weapon", hash = -1716589765, price = 2000, legality = "legal", quantity = 1, weight = 20, objectModel = "w_pi_pistol50" },
    { name = "SNS Pistol", type = "weapon", hash = -1076751822, price = 800, legality = "legal", quantity = 1, weight = 12, objectModel = "w_pi_sns_pistol" },
    { name = "Combat Pistol", type = "weapon", hash = 1593441988, price = 800, legality = "legal", quantity = 1, weight = 15, objectModel = "w_pi_combatpistol" },
    { name = "MK2", type = "weapon", hash = 3219281620, price = 1250, legality = "legal", quantity = 1, weight = 15 },
    { name = "Vintage Pistol", type = "weapon", hash = 137902532, price = 1250, legality = "legal", quantity = 1, weight = 15, objectModel = "w_pi_vintage_pistol" },
    --{ name = "Stun Gun", type = "weapon", hash = 911657153, price = 1500, legality = "legal", quantity = 1, weight = 5, objectModel = "w_pi_stungun" }
    --{ name = "Marksman Pistol", type = "weapon", hash = -598887786, price = 1000, legality = "legal", quantity = 1, weight = 15 }

  },
  ["Shotguns"] = {
    { name = "Pump Shotgun", type = "weapon", hash = 487013001, price = 4000, legality = "legal", quantity = 1, weight = 25, objectModel = "w_sg_pumpshotgun" },
    { name = "Bullpup Shotgun", type = "weapon", hash = -1654528753, price = 6000, legality = "legal", quantity = 1, weight = 30, objectModel = "w_sg_bullpupshotgun" },
    { name = "Musket", type = "weapon", hash = -1466123874, price = 1500, legality = "legal", quantity = 1, weight = 35, objectModel = "w_ar_musket" },
    { name = "Firework Gun", type = "weapon", hash = 2138347493, price = 10000, legality = "legal", quantity = 1, weight = 50, objectModel = "w_lr_firework" }
  },
  ["Extras"] = {
    { name = "Parachute", type = "weapon", hash = "GADGET_PARACHUTE", price = 500, legality = "legal", quantity = 1, weight = 15, objectModel = "prop_parachute" },
    { name = "Body Armor", type = "misc", price = 1000, legality = "legal", quantity = 1, weight = 15, objectModel = "prop_bodyarmour_03" }
  }
}

for category, items in pairs(STORE_ITEMS) do
    for i = 1, #items do
        items[i].notStackable = true
    end
end

local LICENSE_PURCHASE_PRICE = 7000

exports["globals"]:PerformDBCheck("usa_gunshop", "legalweapons")

RegisterServerEvent("gunShop:getItems")
AddEventHandler("gunShop:getItems", function()
    TriggerClientEvent("gunShop:getItems", source, STORE_ITEMS)
end)

RegisterServerEvent("gunShop:requestPurchase")
AddEventHandler("gunShop:requestPurchase", function(category, index, business)
  local usource = source
  local weapon = STORE_ITEMS[category][index]
  local char = exports["usa-characters"]:GetCharacter(usource)
  local permit_status = checkPermit(char)
  if permit_status == "valid" then
    local money = char.get("money")
    if money - STORE_ITEMS[category][index].price >= 0 then
  	  local user_weapons = char.getWeapons()
  	  if  not char.canHoldItem(weapon) then
  		  TriggerClientEvent("usa:notify", source, "Inventory full!")
  		  return
  	  end
      local timestamp = os.date("*t", os.time())
      local letters = {}
      for i = 65,  90 do table.insert(letters, string.char(i)) end -- add capital letters
      local serialEnding = math.random(100000000, 999999999)
      local serialLetter = letters[math.random(#letters)]
      weapon.uuid = math.random(999999999)
      weapon.serialNumber = serialLetter .. serialEnding
      local weaponDB = {}
      weaponDB.name = weapon.name
      weaponDB.serialNumber = serialLetter .. serialEnding
      weaponDB.ownerName = char.getFullName()
      weaponDB.ownerDOB = char.get('dateOfBirth')
      weaponDB.issueDate = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year
      char.giveItem(weapon, 1)
      char.removeMoney(STORE_ITEMS[category][index].price)
      if business then
          exports["usa-businesses"]:GiveBusinessCashPercent(business, STORE_ITEMS[category][index].price)
      end
      TriggerClientEvent("mini:equipWeapon", usource, STORE_ITEMS[category][index].hash) -- equip
      TriggerClientEvent('gunShop:addRecentlyPurchased', usource)
      TriggerClientEvent('usa:notify', usource, 'Purchased: ~y~'..weapon.name..'\n~s~Serial Number: ~y~'..weapon.serialNumber..'\n~s~Price: ~y~$'..STORE_ITEMS[category][index].price)
      TriggerEvent('es:exposeDBFunctions', function(couchdb)
        couchdb.createDocumentWithId("legalweapons", weaponDB, weaponDB.serialNumber, function(success)
            if success then
                print("* Weapon created serial["..weaponDB.serialNumber.."] name["..weaponDB.name.."] owner["..weaponDB.ownerName.."] *")
            else
                print("* Error: Weapon failed to be created!! *")
            end
        end)
      end)
    else
      TriggerClientEvent("usa:notify", source, "Not enough money!")
    end
  elseif permit_status == "suspended" then
    TriggerClientEvent("usa:notify", usource, "Your permit is suspended!")
  elseif permit_status == "none" then
    TriggerClientEvent("usa:notify", usource, "You do not have a valid ~y~Firearm Permit~s~!")
  end
end)

RegisterServerEvent('gunShop:requestOpenMenu')
AddEventHandler('gunShop:requestOpenMenu', function()
  local char = exports["usa-characters"]:GetCharacter(source)
  local permit_status = checkPermit(char)
  if permit_status == 'valid' then
    TriggerClientEvent('gunShop:openMenu', source)
  else
      if permit_status == "none" then
          TriggerClientEvent('usa:notify', source, 'No license! Hold E to purchase one for $' .. exports["globals"]:comma_value(LICENSE_PURCHASE_PRICE))
      elseif permit_status == "suspended" then
          TriggerClientEvent("usa:notify", source, "Your firearm permit is suspended!")
      end
  end
end)

RegisterServerEvent("gunShop:purchaseLicense")
AddEventHandler("gunShop:purchaseLicense", function(business)
  local usource = source
  local timestamp = os.date("*t", os.time())
  local char = exports["usa-characters"]:GetCharacter(usource)
  local m = char.get("money")
  local NEW_GUN_LICENSE = {
    name = 'Firearm Permit',
    number = 'FP' .. tostring(math.random(1, 254367)),
    quantity = 1,
    ownerName = char.getFullName(),
    issued_by = "Ammunation",
    ownerDob = char.get("dateOfBirth"),
    expire = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year + 1,
    status = "valid",
    type = "license",
    notDroppable = true,
    weight = 2.0
  }
  if char.hasItem(NEW_GUN_LICENSE) then
    TriggerClientEvent("usa:notify", usource, "You already have a firearm permit!")
    return
  end
  if char.canHoldItem(NEW_GUN_LICENSE) then
    if m >= LICENSE_PURCHASE_PRICE then
        char.giveItem(NEW_GUN_LICENSE)
        char.removeMoney(LICENSE_PURCHASE_PRICE)
        TriggerClientEvent("usa:notify", usource, "You have accepted the terms and conditions and have been issued a CCW")
        TriggerClientEvent("gunShop:showCCWTerms", usource)
        if business then
            exports["usa-businesses"]:GiveBusinessCashPercent(business, LICENSE_PURCHASE_PRICE)
        end
    else
        TriggerClientEvent("usa:notify", usource, "Not enough money!")
    end
  else
    TriggerClientEvent("usa:notify", usource, "Inventory full!")
  end
end)

function checkPermit(char)
  local license = char.getItem("Firearm Permit")
  if license then
    return license.status
  end
  return "none"
end

function ShowCCWTerms(src)
    TriggerClientEvent('chatMessage', src, '', { 0, 0, 0 }, "^01) The license holder is legally allowed to carry a weapon so long as it remains ^3CONCEALED^0 at all times.")
    Wait(4000)
    TriggerClientEvent('chatMessage', src, '', { 0, 0, 0 }, "^02) If contacted by a law enforcement officer for any reason, and the license holder is armed, the license holder shall immediately inform the officer they are a CCW licensee and when the officer requests the license holder’s CCW license, the license holder will provide their CCW license as proof they are legally carrying a concealed weapon.")
    Wait(9000)
    TriggerClientEvent('chatMessage', src, '', { 0, 0, 0 }, "^03) License holder shall surrender the CCW license and/or concealed weapon to any sworn peace officer upon demand.")
    Wait(5000)
    TriggerClientEvent('chatMessage', src, '', { 0, 0, 0 }, "^04) License holder shall not unnecessarily display or expose the concealed weapon or license.")
end
