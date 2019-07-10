local markets = {
  ['marketA'] = {
    ['coords'] = {140.8, -1920.5, 21.0}, -- los santos
    ['items'] = {
      {name = 'Lockpick', type = 'misc', price = 135, legality = 'illegal', quantity = 1, weight = 5, stock = math.random(0, 7)},
      {name = 'Pistol', type = 'weapon', hash = 453432689, price = 3000, legality = 'illegal', quantity = 1, weight = 10, stock = math.random(0, 3), objectModel = "w_pi_pistol"},
      {name = 'Vintage Pistol', type = 'weapon', hash = 137902532, price = 4000, legality = 'illegal', quantity = 1, weight = 10, stock = math.random(0, 3), objectModel = "w_pi_vintage_pistol"},
      {name = 'Heavy Pistol', type = 'weapon', hash = -771403250, price = 4500, legality = 'illegal', quantity = 1, weight = 15, stock = math.random(0, 3), objectModel = "w_pi_heavypistol"},
      {name = 'Pistol .50', type = 'weapon', hash = -1716589765, price = 4500, legality = 'illegal', quantity = 1, weight = 18, stock = math.random(0, 2), objectModel = "w_pi_pistol50"},
      {name = 'Pump Shotgun', type = 'weapon', hash = 487013001, price = 9000, legality = 'illegal', quantity = 1, weight = 30, stock = math.random(0, 2), objectModel = "w_sg_pumpshotgun"},
      {name = 'Hotwiring Kit', type = 'misc', price = 250, legality = 'illegal', quantity = 1, weight = 10, stock = math.random(0, 6)},
      { name = "AP Pistol", type = "weapon", hash = 0x22D8FE39, price = 50000, legality = "illegal", quantity = 1, weight = 15, stock = math.random(0, 2), objectModel = "w_pi_appistol" },
      { name = "Sawn-off", type = "weapon", hash = 0x7846A318, price = 30000, legality = "illegal", quantity = 1, weight = 30, stock = math.random(0, 3), objectModel = "w_sg_sawnoff", },
      { name = "Micro SMG", type = "weapon", hash = 324215364, price = 40000, legality = "illegal", quantity = 1, weight = 30, stock = math.random(0, 2), objectModel = "w_sb_microsmg"},
      {name = 'SMG', type = 'weapon', hash = 736523883, price = 75000, legality = 'illegal', quantity = 1, weight = 55, stock = math.random(0, 1), objectModel = "w_sb_smg"}
    },
    ["pedHash"] = -48477765
  },
  ['marketB'] = {
    ['coords'] = {1380.87, 2172.51, 97.81}, -- sandy shores
    ['items'] = {
      {name = 'Lockpick', type = 'misc', price = 135, legality = 'illegal', quantity = 1, weight = 5, stock = math.random(1, 5)},
      {name = 'Hotwiring Kit', type = 'misc', price = 250, legality = 'illegal', quantity = 1, weight = 10, stock = math.random(0, 6)},
      {name = 'Heavy Shotgun', type = 'weapon', hash = 984333226, price = 20000, legality = 'illegal', quantity = 1, weight = 35, stock = math.random(0, 2), objectModel = "w_sg_heavyshotgun"},
      {name = 'SNS Pistol', type = 'weapon', hash = -1076751822, price = 3500, legality = 'illegal', quantity = 1, weight = 8, stock = math.random(0, 3), objectModel = "w_pi_sns_pistol"},
      {name = 'Combat Pistol', type = 'weapon', hash = 1593441988, price = 5000, legality = 'illegal', quantity = 1, weight = 10, stock = math.random(0, 3), objectModel = "w_pi_combatpistol"},
      {name = 'Switchblade', type = 'weapon', hash = -538741184, price = 1500, legality = 'illegal', quantity = 1, weight = 5, stock = math.random(0, 3)},
      {name = 'Brass Knuckles', type = 'weapon', hash = -656458692, price = 1100, legality = 'illegal', quantity = 1, weight = 5, stock = math.random(0, 5)},
      { name = "Molotov", type = "weapon", hash = 615608432, price = 150, legality = "illegal", quantity = 1, weight = 20, stock = math.random(0, 3), objectModel = "w_ex_molotov"},
      { name = "Machine Pistol", type = "weapon", hash = -619010992, price = 45000, legality = "illegal", quantity = 1, weight = 20, stock = math.random(0, 2) },
      { name = "Tommy Gun", type = "weapon", hash = 1627465347, price = 110000, legality = "illegal", quantity = 1, weight = 45, stock = math.random(0, 2), objectModel = "w_sb_gusenberg" },
      { name = "AK47", type = "weapon", hash = -1074790547, price = 100000, legality = "illegal", quantity = 1, weight = 45, stock = math.random(0, 2), objectModel = "w_ar_assaultrifle" },
      { name = "Carbine", type = "weapon", hash = -2084633992, price = 100000, legality = "illegal", quantity = 1, weight = 45, stock = math.random(0, 2), objectModel = "w_ar_carbinerifle" }
    },
    ["pedHash"] = -1773333796
  }
}

for store, info in pairs(markets) do
    for i = 1, #info["items"] do
        if info["items"][i].name ~= "Lockpick" and info["items"][i].name ~= "Hotwiring Kit" then
            info["items"][i].notStackable = true
        end
    end
end

RegisterServerEvent("blackMarket:loadItems")
AddEventHandler("blackMarket:loadItems", function()
  TriggerClientEvent("blackMarket:loadItems", source, markets)
end)

RegisterServerEvent("blackMarket:requestPurchase")
AddEventHandler("blackMarket:requestPurchase", function(key, itemIndex)
    local char = exports["usa-characters"]:GetCharacter(source)
    local weapon = markets[key]['items'][itemIndex]
    if weapon.stock > 0 then
        weapon.uuid = math.random(999999999)
        if char.canHoldItem(weapon) then
            if weapon.price <= char.get("money") then -- see if user has enough money
                char.giveItem(weapon, 1)
                char.removeMoney(weapon.price)
                if weapon.type == "weapon" then
                    TriggerClientEvent("blackMarket:equipWeapon", source, weapon.hash, weapon.name) -- equip
                end
                markets[key]['items'][itemIndex].stock = weapon.stock - 1
                TriggerClientEvent("usa:notify", source, "Purchased: ~y~"..weapon.name..'\n~s~Price: ~y~$'..exports["globals"]:comma_value(weapon.price)..'.00')
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
