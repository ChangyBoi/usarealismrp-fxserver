math.randomseed(os.time());
math.random(); math.random(); -- prepare random price generator

local markets = {
  ['marketA'] = {
    ['coords'] = {-607.15, -1634.53, 33.05}, -- los santos
    ['items'] = {
      {name = 'Lockpick', type = 'misc', price = 150, legality = 'illegal', quantity = 1, weight = 5, stock = math.random(0, 7)},
      {name = 'Pistol', type = 'weapon', hash = 453432689, price = 3000, legality = 'illegal', quantity = 1, weight = 10, stock = math.random(0, 3), objectModel = "w_pi_pistol"},
      {name = 'Vintage Pistol', type = 'weapon', hash = 137902532, price = 4000, legality = 'illegal', quantity = 1, weight = 10, stock = math.random(0, 3), objectModel = "w_pi_vintage_pistol"},
      {name = 'Heavy Pistol', type = 'weapon', hash = -771403250, price = 4500, legality = 'illegal', quantity = 1, weight = 15, stock = math.random(0, 3), objectModel = "w_pi_heavypistol"},
      {name = 'Pistol .50', type = 'weapon', hash = -1716589765, price = 4500, legality = 'illegal', quantity = 1, weight = 18, stock = math.random(0, 2), objectModel = "w_pi_pistol50"},
      {name = 'Pump Shotgun', type = 'weapon', hash = 487013001, price = 9000, legality = 'illegal', quantity = 1, weight = 30, stock = math.random(0, 2), objectModel = "w_sg_pumpshotgun"},
      {name = 'Hotwiring Kit', type = 'misc', price = 300, legality = 'illegal', quantity = 1, weight = 10, stock = math.random(0, 6)},
      { name = "AP Pistol", type = "weapon", hash = 0x22D8FE39, price = 20000, legality = "illegal", quantity = 1, weight = 15, stock = math.random(0, 2), objectModel = "w_pi_appistol" },
      { name = "Sawn-off", type = "weapon", hash = 0x7846A318, price = 30000, legality = "illegal", quantity = 1, weight = 30, stock = math.random(0, 3), objectModel = "w_sg_sawnoff", },
      { name = "Micro SMG", type = "weapon", hash = 324215364, price = 35000, legality = "illegal", quantity = 1, weight = 30, stock = math.random(0, 2), objectModel = "w_sb_microsmg"},
      { name = 'SMG', type = 'weapon', hash = 736523883, price = 45000, legality = 'illegal', quantity = 1, weight = 35, stock = math.random(0, 1), objectModel = "w_sb_smg"},
      { name = "Police Armor", type = "misc", price = 5000, legality = "illegal", quantity = 1, weight = 25, stock = math.random(0, 3), objectModel = "prop_bodyarmour_03" },
      { name = "Empty 9mm Mag [12]", type = "magazine", legality = "legal", price = 100, weight = 5, receives = "9mm", MAX_CAPACITY = 12, currentCapacity = 0, legality = "legal", objectModel = "w_pi_combatpistol_mag1" },
      { name = "Empty 9mm Mag [7]", type = "magazine", legality = "legal", price = 100, weight = 5, receives = "9mm", MAX_CAPACITY = 7, currentCapacity = 0, legality = "legal", objectModel = "w_pi_combatpistol_mag1" },
      { name = "Empty .45 Mag [18]", type = "magazine", legality = "legal", price = 200, weight = 5, receives = ".45", MAX_CAPACITY = 18, currentCapacity = 0, legality = "legal", objectModel = "w_pi_heavypistol_mag2"},
      { name = "Empty .50 Cal Mag [9]", type = "magazine", legality = "legal", price = 200, weight = 5, receives = ".50 Cal", MAX_CAPACITY = 9, currentCapacity = 0, legality = "legal", objectModel = "w_pi_combatpistol_mag1" },
      { name = "Empty 9x18mm Mag [18]", type = "magazine", legality = "legal", price = 100, weight = 5, receives = "9x18mm", MAX_CAPACITY = 18, currentCapacity = 0, objectModel = "w_pi_heavypistol_mag2" },
      { name = "Empty .45 Mag [16]", type = "magazine", legality = "legal", price = 200, weight = 5, receives = ".45", MAX_CAPACITY = 16, currentCapacity = 0, objectModel = "w_pi_heavypistol_mag2" },
      { name = "Empty 9mm Mag [30]", type = "magazine", legality = "legal", price = 200, weight = 5, receives = "9mm", MAX_CAPACITY = 12, currentCapacity = 0, objectModel = "w_sb_gusenberg_mag1" }
    },
    ["pedHash"] = -48477765
  },
  ['marketB'] = {
    ['coords'] = {1579.81, 3613.78, 38.78}, -- sandy shores
    ['items'] = {
      {name = 'Lockpick', type = 'misc', price = 150, legality = 'illegal', quantity = 1, weight = 5, stock = math.random(1, 5)},
      {name = 'Hotwiring Kit', type = 'misc', price = 300, legality = 'illegal', quantity = 1, weight = 10, stock = math.random(0, 6)},
      {name = 'Heavy Shotgun', type = 'weapon', hash = 984333226, price = 20000, legality = 'illegal', quantity = 1, weight = 35, stock = math.random(0, 2), objectModel = "w_sg_heavyshotgun"},
      {name = 'SNS Pistol', type = 'weapon', hash = -1076751822, price = 3500, legality = 'illegal', quantity = 1, weight = 8, stock = math.random(0, 3), objectModel = "w_pi_sns_pistol"},
      {name = 'Glock', type = 'weapon', hash = 1593441988, price = 5000, legality = 'illegal', quantity = 1, weight = 10, stock = math.random(0, 3), objectModel = "w_pi_combatpistol"},
      {name = 'Switchblade', type = 'weapon', hash = -538741184, price = 1500, legality = 'illegal', quantity = 1, weight = 5, stock = math.random(0, 3)},
      {name = 'Brass Knuckles', type = 'weapon', hash = -656458692, price = 1100, legality = 'illegal', quantity = 1, weight = 5, stock = math.random(0, 5)},
      {name = "Machine Pistol", type = "weapon", hash = -619010992, price = tonumber(tostring(math.random(22, 30)) .. "000"), legality = "illegal", quantity = 1, weight = 20, stock = math.random(0, 2) },
      { name = "Empty 12 Gauge Shells Mag [6]", type = "magazine", legality = "legal", price = 100, weight = 5, receives = "12 Gauge Shells", MAX_CAPACITY = 6, currentCapacity = 0 },
      { name = "Empty .45 Mag [6]", type = "magazine", legality = "legal", price = 100, weight = 5, receives = ".45", MAX_CAPACITY = 6, currentCapacity = 0, objectModel = "w_pi_combatpistol_mag1" },
      { name = "Empty 9mm Mag [12]", type = "magazine", legality = "legal", price = 70, weight = 5, receives = "9mm", MAX_CAPACITY = 12, currentCapacity = 0, objectModel = "w_pi_combatpistol_mag1" },
    },
    ["pedHash"] = -1773333796
  },
  ['marketC'] = {
    ['coords'] = {2549.91, 4639.19, 34.08}, -- Grapeseed
    ['items'] = {
      { name = "Molotov", type = "weapon", hash = 615608432, price = 300, legality = "illegal", quantity = 1, weight = 20, stock = math.random(0, 3), objectModel = "w_ex_molotov"},
      { name = "Tommy Gun", type = "weapon", hash = 1627465347, price = 50000, legality = "illegal", quantity = 1, weight = 45, stock = math.random(0, 2), objectModel = "w_sb_gusenberg" },
      { name = "AK47", type = "weapon", hash = -1074790547, price = tonumber(tostring(math.random(30, 60)) .. "000"), legality = "illegal", quantity = 1, weight = 45, stock = math.random(0, 2), objectModel = "w_ar_assaultrifle" },
      { name = "Carbine", type = "weapon", hash = -2084633992, price = tonumber(tostring(math.random(30, 60)) .. "000"), legality = "illegal", quantity = 1, weight = 45, stock = math.random(0, 2), objectModel = "w_ar_carbinerifle" },
      { name = "Compact Rifle", type = "weapon", hash = 1649403952, price = tonumber(tostring(math.random(20, 30)) .. "000"), legality = "illegal", quantity = 1, weight = 45, stock = math.random(0, 2), objectModel = "w_ar_assaultrifle" },
      { name = "Empty .45 Mag [30]", type = "magazine", price = 150, weight = 5, receives = ".45", MAX_CAPACITY = 30, currentCapacity = 0, objectModel = "w_pi_heavypistol_mag2" },
      { name = "Empty 7.62mm Mag [30]", type = "magazine", price = 150, weight = 5, receives = "7.62mm", MAX_CAPACITY = 30, currentCapacity = 0, objectModel = "w_ar_carbinerifle_mag1" },
      { name = "Empty 5.56mm Mag [30]", type = "magazine", price = 150, weight = 5, receives = "5.56mm", MAX_CAPACITY = 30, currentCapacity = 0, objectModel = "w_ar_carbinerifle_mag1" },
    },
    ['pedHash'] = 'a_m_o_soucent_03'
  },
  ['marketD'] = {
    ['coords'] = {113.24684906006, -1967.5310058594, 21.317762374878}, -- Grove St. house interior
    ['items'] = {
      { name = "Large Firework", type = "misc", price = 2000, legality = "illegal", quantity = 1, weight = 15, stock = math.random(1, 10), objectModel = "ind_prop_firework_03" },
      { name = "Firework Gun", type = "weapon", hash = 2138347493, price = 5000, legality = "illegal", quantity = 1, weight = 50, stock = math.random(1, 3), objectModel = "w_lr_firework" },
      { name = "Firework Projectile", legality = "illegal", type = "ammo", price = 400, weight = 15, quantity = 1, stock = math.random(1, 8) },
      { name = "12 Gauge Shells", type = "ammo", price = 300, weight = 0.5, quantity = 10, legality = "legal", objectModel = "prop_ld_ammo_pack_02" },
      { name = ".45 Bullets", type = "ammo", price = 375, weight = 0.5, quantity = 10, legality = "legal", objectModel = "prop_ld_ammo_pack_01" },
      { name = "9mm Bullets", type = "ammo", price = 300, weight = 0.5, quantity = 10, legality = "legal", objectModel = "prop_ld_ammo_pack_01" },
      { name = ".50 Cal Bullets", type = "ammo", price = 500, weight = 0.5, quantity = 10, legality = "legal", objectModel = "prop_ld_ammo_pack_01" },
      { name = "9x18mm Bullets", type = "ammo", price = 350, weight = 0.5, quantity = 10, legality = "legal", objectModel = "prop_ld_ammo_pack_01" },
      { name = "5.56mm Bullets", type = "ammo", price = 600, weight = 0.5, quantity = 10, legality = "legal", objectModel = "prop_ld_ammo_pack_03"  },
      { name = "7.62mm Bullets", type = "ammo", price = 600, weight = 0.5, quantity = 10, legality = "legal", objectModel = "prop_ld_ammo_pack_03" }
    },
    ['pedHash'] = 'a_m_o_soucent_03',
    ['3dTextDistance'] = 7,
    ['pedScenario'] = "WORLD_HUMAN_SMOKING_POT"
  }
}

-- x = 113.21036529541, y = -1967.2863769531, z = 21.317756652832

local openingHours = math.random(0, 4)
local closingHours = math.random(5, 7)

for store, info in pairs(markets) do
    for i = 1, #info["items"] do
        if info["items"][i].type and info["items"][i].type == "weapon" or info["items"][i].type == "magazine" then
            info["items"][i].notStackable = true
        end
    end
end

RegisterServerEvent("blackMarket:loadItems")
AddEventHandler("blackMarket:loadItems", function()
  TriggerClientEvent("blackMarket:loadItems", source, markets)
end)

RegisterServerEvent("blackMarket:openAndClosingHours")
AddEventHandler("blackMarket:openAndClosingHours", function()
    TriggerClientEvent("blackMarket:operatingHours", source, openingHours, closingHours)
end)

RegisterServerEvent("blackMarket:requestPurchase")
AddEventHandler("blackMarket:requestPurchase", function(key, itemIndex)
    local char = exports["usa-characters"]:GetCharacter(source)
    local selectedItem = markets[key]['items'][itemIndex]
    if selectedItem.stock == nil then
      if selectedItem.type == "ammo" then
        selectedItem.stock = math.random(10, 20)
      else 
        selectedItem.stock = math.random(0, 5)
      end
    end
    if selectedItem.stock > 0 then
        selectedItem.uuid = exports.globals:generateID()
        if char.canHoldItem(selectedItem) then
            if selectedItem.price <= char.get("money") then -- see if user has enough money
                char.giveItem(selectedItem, (selectedItem.quantity or 1))
                char.removeMoney(selectedItem.price)
                if selectedItem.type == "weapon" then
                    TriggerClientEvent("blackMarket:equipWeapon", source, selectedItem.hash, selectedItem.name, false) -- equip
                end
                markets[key]['items'][itemIndex].stock = selectedItem.stock - 1
                TriggerClientEvent("usa:notify", source, "Purchased: ~y~"..selectedItem.name..'\n~s~Price: ~y~$'..exports["globals"]:comma_value(selectedItem.price)..'.00')
            else
                TriggerClientEvent("usa:notify", source, "You cannot afford this purchase!")
            end
        else
            TriggerClientEvent("usa:notify", source, "Inventory is full!")
        end
    else
        TriggerClientEvent("usa:notify", source, "Out of stock! Come back tomorrow!")
    end
end)
