MechanicHelper = {}

MechanicHelper.animations = {}
MechanicHelper.animations.repair = {}
MechanicHelper.animations.repair.dict = "mini@repair"
MechanicHelper.animations.repair.name = "fixing_a_player"

MechanicHelper.REPAIR_TIME = 60000
MechanicHelper.UPGRADE_INSTALL_TIME = 180000

MechanicHelper.UPGRADE_FUNC_MAP = {
    ["topspeed1"] = function(veh, amountIncrease)
        ModifyVehicleTopSpeed(veh, 0.0) -- reset first to avoid doubling up issue
        ModifyVehicleTopSpeed(veh, amountIncrease)
    end,
    ["topspeed2"] = function(veh, amountIncrease)
        ModifyVehicleTopSpeed(veh, 0.0) -- reset first to avoid doubling up issue
        ModifyVehicleTopSpeed(veh, amountIncrease)
    end,
    ["topspeed3"] = function(veh, amountIncrease)
        ModifyVehicleTopSpeed(veh, 0.0) -- reset first to avoid doubling up issue
        ModifyVehicleTopSpeed(veh, amountIncrease)
    end,
    ["topspeed4"] = function(veh, amountIncrease)
        ModifyVehicleTopSpeed(veh, 0.0) -- reset first to avoid doubling up issue
        ModifyVehicleTopSpeed(veh, amountIncrease)
    end
}

MechanicHelper.getClosestVehicle = function(maxRange)
    local me = PlayerPedId()
    local mycoords = GetEntityCoords(me)
    local closest = {}
    closest.dist = 999999999
    closest.veh = nil
    for veh in exports.globals:EnumerateVehicles() do
        local vehCoords = GetEntityCoords(veh)
        local dist = Vdist(mycoords.x, mycoords.y, mycoords.z, vehCoords.x, vehCoords.y, vehCoords.z)
        if dist < closest.dist and dist < (maxRange or 500) then
            closest.dist = dist
            closest.veh = veh
        end
    end
    return closest.veh
end

MechanicHelper.repairVehicle = function(veh, cb)
    local success = false
    SetVehicleDoorOpen(veh, 4, false, false)
    local me = PlayerPedId()
    local beginTime = GetGameTimer()
    while GetGameTimer() - beginTime < MechanicHelper.REPAIR_TIME do
        exports.globals:DrawTimerBar(beginTime, MechanicHelper.REPAIR_TIME, 1.42, 1.475, 'REPAIRING')
        if not IsEntityPlayingAnim(me, MechanicHelper.animations.repair.dict, MechanicHelper.animations.repair.name, 3) then
            RequestAnimDict(MechanicHelper.animations.repair.dict)
            TaskPlayAnim(me, MechanicHelper.animations.repair.dict, MechanicHelper.animations.repair.name, 8.0, 1.0, -1, 15, 1.0, 0, 0, 0)
        end
        Wait(1)
    end
    local fixedChance = math.random()
    if fixedChance <= 0.55 then
        SetVehicleUndriveable(veh, false)
        SetVehicleEngineHealth(veh, 800.0)
        FixAllTires(veh)
        success = true
    end
    ClearPedTasks(me)
    Wait(500)
    SetVehicleDoorShut(veh, 4, false)
    cb(success)
end

MechanicHelper.installUpgrade = function(veh, upgrade, cb)
    SetVehicleDoorOpen(veh, 4, false, false)
    local me = PlayerPedId()
    local beginTime = GetGameTimer()
    while GetGameTimer() - beginTime < MechanicHelper.UPGRADE_INSTALL_TIME do
        exports.globals:DrawTimerBar(beginTime, MechanicHelper.UPGRADE_INSTALL_TIME, 1.42, 1.475, 'INSTALLING')
        if not IsEntityPlayingAnim(me, MechanicHelper.animations.repair.dict, MechanicHelper.animations.repair.name, 3) then
            RequestAnimDict(MechanicHelper.animations.repair.dict)
            TaskPlayAnim(me, MechanicHelper.animations.repair.dict, MechanicHelper.animations.repair.name, 8.0, 1.0, -1, 15, 1.0, 0, 0, 0)
        end
        Wait(1)
    end
    local plate = GetVehicleNumberPlateText(veh)
    MechanicHelper.UPGRADE_FUNC_MAP[upgrade.id](veh, upgrade.increaseAmount) -- call appropriate native
    TriggerServerEvent("mechanic:upgradeInstalled", plate)
    ClearPedTasks(me)
    cb()
    Wait(500)
    SetVehicleDoorShut(veh, 4, false)
end

function FixAllTires(veh)
    SetVehicleTyreFixed(veh, 0)
    SetVehicleTyreFixed(veh, 1)
    SetVehicleTyreFixed(veh, 2)
    SetVehicleTyreFixed(veh, 3)
    SetVehicleTyreFixed(veh, 4)
end

--[[
local veh = GetVehiclePedIsIn(PlayerPedId(), true)
ModifyVehicleTopSpeed(veh, 20.0)
--]]