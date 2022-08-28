Config = {}

-- ALWAYS GIVE THEM SEPARATE 'ID'!
Config.PokerTables = {
    { id = 1, pos = vector3(1111.128, 217.078, -50.440), heading = 165.9, blind = 20 },
    { id = 2, pos = vector3(1104.686, 208.9376, -50.440), heading = 56.8, blind = 100 }
}

Config.SitDownKey = 38
-- DrawText3D rendering on the table
Config.RenderTableText = true

-- This will not call the DisplayRadar native function if set to true.
Config.AntiCheatRadarDebug = false

-- Reduce or increase the table reactive range.
Config.TableDistance = 4.0

-- This is for the client translations. (DrawText3D)
Config.Translations = {
    Poker = "~h~Poker",
    Blinds = "Blinds: %s/%s"
}

-- CREATING TEST TABLES, COMMENT OR DELETE THIS FUNCTION IF YOU DO NOT NEED.
-- After you entered the command, the table coords will show up in your client console. (F8)
-- Then just write the coords and the neccessary variables in the Config.PokerTables
--[[
local testTable = nil
RegisterCommand('createpokertable', function()
    if DoesEntityExist(testTable) then
        return
    end

    local pokermodel = 'pokerasztal'
    RequestModel(pokermodel)
    while not HasModelLoaded(pokermodel) do
        print('not exist')
        Citizen.Wait(100)
    end

    testTable = CreateObject(pokermodel, GetEntityCoords(PlayerPedId()), false, false, false)
    SetEntityHeading(testTable, GetEntityHeading(PlayerPedId()))
    PlaceObjectOnGroundProperly(testTable)

    Citizen.Wait(1000)
    local pos = GetEntityCoords(testTable)
    local _, groundZ, offsets = GetGroundZCoordWithOffsets(pos.x, pos.y, pos.z)
    print(vector3(pos.x, pos.y, groundZ))
    print(GetEntityHeading(testTable))

    Citizen.Wait(2500)
    if DoesEntityExist(testTable) then
        DeleteObject(testTable)
    end
end)
--]]

-- THESE ARE NOT FOR YOU! --
Config.DealerAnimDictShared = 'anim_casino_b@amb@casino@games@shared@dealer@'
Config.PlayerAnimDictShared = 'anim_casino_b@amb@casino@games@shared@player@'


if IsDuplicityVersion() then
    -- Do not modify this config_getPokerTables function.
    exports('config_getPokerTables', function()
        return Config.PokerTables
    end)
end