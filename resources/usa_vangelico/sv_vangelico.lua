-- Buy ear and wrist jewelry like earrings, watches, and bracelets
-- by: minipunch

local Wrist = {
    Left = 6,
    Right = 7
}

local ITEMS = {
    male = {
        left_wrist = { 1, 3, 4, 5, 6, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67 },
        right_wrist = { 0, 1, 2, 30, 31, 32, 33, 34, 35, 36, 37 }
    },
    female = {
        left_wrist = { 2, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57 },
        right_wrist = { 0, 1, 2, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44 }
    }
}

local ITEM_PURCHASE_PRICE = 3000

RegisterServerEvent("vangelico:loadItems")
AddEventHandler("vangelico:loadItems", function()
  TriggerClientEvent("vangelico:loadItems", source, ITEMS)
end)

RegisterServerEvent("vangelico:purchase")
AddEventHandler("vangelico:purchase", function(cart, business)
    local purchasedItems = 0
    local cartTotal = 0
    local char = exports["usa-characters"]:GetCharacter(source)
    for wristPropIndex, info in pairs(cart) do
        -- take money
        if char.get("money") >= ITEM_PURCHASE_PRICE then
            TakeMoney(char, ITEM_PURCHASE_PRICE, business)
            -- save updated char appearance 
            SaveSelection(char, wristPropIndex, info)
            -- increment counters
            purchasedItems = purchasedItems + 1
            cartTotal = cartTotal + ITEM_PURCHASE_PRICE
        else
            TriggerClientEvent("usa:notify", source, "Not enough money for " .. GetWristDisplayName(wristPropIndex) .. " wrist item")
            break
        end
    end
    if purchasedItems > 0 then
        -- notify
        TriggerClientEvent("usa:notify", source, "Purchased " .. purchasedItems .. " item(s) for $" .. exports["globals"]:comma_value(cartTotal))
    end
end)

RegisterServerEvent("vangelico:clear")
AddEventHandler("vangelico:clear", function(index)
    local char = exports["usa-characters"]:GetCharacter(source)
    local appearance = char.get("appearance")
    appearance["props"][index] = nil
    appearance["propstexture"][index] = nil
    char.set("appearance", appearance)
end)

function TakeMoney(char, price, business)
    char.removeMoney(price)
    if business then
        exports["usa-businesses"]:GiveBusinessCashPercent(business, price)
    end
end

function SaveSelection(char, wristPropIndex, info)
    local appearance = char.get("appearance")
    appearance["props"][tostring(wristPropIndex)] = info.val
    appearance["propstexture"][tostring(wristPropIndex)] = info.textureVal
    char.set("appearance", appearance)
end

function GetWristDisplayName(index)
    if index == Wrist.Left then
        return "left"
    elseif index == Wrist.Right then
        return "right"
    end
end