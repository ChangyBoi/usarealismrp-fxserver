local blips = {
	--[[{ title="Ammu-Nation", colour=4, id=110, x=-330.184, y=6083.23, z=31.4548 },
	{ title="Ammu-Nation", colour=4, id=110, x=1701.292, y=3750.450, z=34.365 },
    { title="Ammu-Nation", colour=4, id=110, x=237.428, y=-43.655, z=69.698 },
    { title="Ammu-Nation", colour=4, id=110, x=843.604, y=-1017.784, z=27.546 },
    { title="Ammu-Nation", colour=4, id=110, x=-663.8073, y=-947.5537, z=21.509 },
    { title="Ammu-Nation", colour=4, id=110, x=-1320.983, y=-389.260, z=36.483 },
    { title="Ammu-Nation", colour=4, id=110, x=-1109.053, y=2686.300, z=18.775 },
    { title="Ammu-Nation", colour=4, id=110, x=2568.379, y=309.629, z=108.461 },
    { title="Ammu-Nation", colour=4, id=110, x=-3157.450, y=1079.633, z=20.692 },
    { title="Ammu-Nation", colour=4, id=110, x=16.6405, y=-1116.9636, z=29.7911 },
    { title="Ammu-Nation", colour=4, id=110, x=812.4276, y=-2145.2118, z=29.3063 },]]
	--{ title="Car Dealership", colour=76, id=225, scale = 0.7, x=120.924, y=6624.605, z=31.000 },
	--{ title="DMV", colour=4, id=355, x= -447.845, y = 6013.775, z = 30.716 },
	{ title="DMV", colour=4, id=355, scale = 0.7, x = -544.857, y = -204.422, z = 37.2152 },
	--{ title="Bubba's Tow Co.", colour=64, id=68, x = -196.027, y = 6265.625, z = 30.489 }, -- paleto
	--{ title="Bubba's Tow Co.", colour=64, id=68, x = 2363.89, y = 3126.85, z = 47.211 }, -- sandy shores
	--{ title="Bubba's Tow Co.", colour=64, id=68, x = 408.03, y = -1624.62, z = 28.29 }, -- los santos
	--[[{ title="General Store", colour = 24 , id = 52, x=1961.061, y=3741.604, z=32.343 },
    { title="General Store", colour = 24 , id = 52, x=374.586, y=326.037, z=103.566     },
    { title="General Store", colour = 24 , id = 52, x=1136.534, y=-971.131, z=46.415 },
	{ title="General Store", colour = 24 , id = 52, x = 1136.3, y = -981.0, z = 45.5 },
	{ title="General Store", colour = 24 , id = 52, x=-1224.188, y=-907.065, z=12.326 },
	{ title="General Store", colour = 24 , id = 52, x=26.453, y=-1347.059, z=29.497 },
	{ title="General Store", colour = 24 , id = 52, x=-48.437, y=-1756.889, z=29.421 },
	{ title="General Store", colour = 24 , id = 52, x=-707.712, y=-914.231, z=19.215 },
	{ title="General Store", colour = 24 , id = 52, x=1166.5310, y=2708.920, z=38.157 },
	{ title="General Store", colour = 24 , id = 52, x=1698.458, y=4924.744, z=43.063 },
	{ title="General Store", colour = 24 , id = 52, x=1729.413, y=6414.426, z=35.037 },
	{ title="General Store", colour = 24 , id = 52, x=-3039.294, y=586.014, z=7.908 },
	{ title="General Store", colour = 24 , id = 52, x=1162.799, y=-324.155, z=69.205 },
	{ title="General Store", colour = 24 , id = 52, x=2556.836, y=382.416, z=108.622 },
	{ title="General Store", colour = 24 , id = 52, x=2678.409, y=3280.871, z=55.241 },
	{ title="General Store", colour = 24 , id = 52, x=547.486, y=2670.635, z=42.156 },
	{ title="General Store", colour = 24 , id = 52, x=-1820.852, y=792.453, z=138.119 },
	{ title="General Store", colour = 24 , id = 52, x=-3242.260, y=1001.569, z=12.830 },
	{ title="General Store", colour = 24 , id = 52, x=-2968.126, y=390.579, z=15.043 },
  	--{ title="General Store", colour = 24 , id = 52, x=-1487.241, y=379.843, z=40.163 },]]
	{ title="Police Department", colour = 38 , id = 60, scale = 0.7, x=451.255, y=-992.41, z=30.6896 }, -- LOS SANTOS
	{ title="Police Department", colour = 38 , id = 60, scale = 0.7, x = 638.9, y = 1.9, z = 81.8 }, -- LOS SANTOS, vinewood, elgin ave.
	{ title="Police Department", colour = 38 , id = 60, scale = 0.7, x = 826.5, y = -1291.3, z = 27.3 }, -- LOS SANTOS, la mesa PD
	{ title="Police Department", colour = 38 , id = 60, scale = 0.7, x = 370.3, y = -1608.4, z = 28.3 }, -- LOS SANTOS, davis PD
	{ title="Police Department", colour = 38 , id = 60, scale = 0.7, x = -1107.5, y = -847.5, z = 19.3 }, -- LOS SANTOS, vespucci PD
	{ title="Sheriff's Office", colour = 38 , id = 60, scale = 0.7, x=1853.2, y=3687.74, z=34.267 }, -- SANDY
	{ title="Sheriff's Office", colour = 38 , id = 60, scale = 0.7, x=-447.041, y=6012.97, z=31.7164 }, -- PALETO
	{ title="Fire Department", colour = 1, id = 60, scale = 0.7, x=207.106, y=-1641.45, z=28.5 }, -- LOS SANTOS
	{ title="Fire Department", colour = 1, id = 60, scale = 0.7, x=-375.435, y=6114.61, z=35.4397 }, -- PALETO
	{ title="Fire Department", colour = 1, id = 60, scale = 0.7, x=1694.01, y=3589.87, z=40.3212 }, -- SANDY
	{ title="Hospital", colour = 51, id = 61, scale = 0.7, x = -240.10, y = 6324.22, z = 32.43 }, -- paleto
	--{ title="Hospital", colour = 48, id = 61, x = 360.3, y = -548.9, z = 28.8 }, -- LS, pillbox hill
	{ title="Hospital", colour = 51, id = 61, scale = 0.7, x = 308.1, y = -1434.7,  z = 29.9 },
	{ title="Hospital", colour = 51, id = 61, scale = 0.7, x = 360.5, y = -584.7, z = 28.8 },
	{ title="Hospital", colour = 51, id = 61, scale = 0.7, x = -473.4, y = -339.6, z = 35.2 }, -- mt. zonoah
	{ title="Strip Club", colour = 4, id = 121, scale = 0.7, x=129.607, y=-1299.83, z=29.2327 },
	--{ title="FBI", colour = 47, id = 88, x=140.577, y=-768.375, z=45.752 },
	--{ title="Airport", colour = 30, id = 307, x=-1329.32, y=-3045.92, z=13.944 },
	--{ title="The Hen House", colour = 83, id = 93, x= -304.092, y= 6264.582, z= 31.530 },
	{ title="Tequilala", colour = 15, id = 93, scale = 0.7, x=-564.778, y=274.195, z=83.0197 },
	{ title="Bahama Mamas", colour = 15, id = 93, scale = 0.7, x=-1388.94, y=-585.919, z=29.2195 },
	{ title="Comedy Club", colour = 4, id = 362, scale = 0.7, x = -429.9, y = 261.6, z = 83.0 },
	{ title="Yellow Jack", colour = 15, id = 93, scale = 0.7, x = 1986.1, y = 3050.57, z = 47.2151 },
	{ title="Nightclub", colour = 83, id = 136, x = -337.23, y = 207.189, z = 88.57, scale = 0.95},
	--{ title="Downtown Taxi", colour = 60, id = 198, x=895.563, y=-179.536, z=74.7003 },
	--{ title="Downtown Taxi", colour = 60, id = 198, x = -41.306, y = 6436.432, z = 30.490 },
	--{ title="Downtown Taxi", colour = 60, id = 198, x = 895.2, y = -179.5, z = 74.7 },
	--{ title="Bank", colour = 24, id = 108, x=-106.358, y=6474.25, z=30.600 },
	--{ title="Seaview Aircraft", colour = 60, id = 251, x=-943.103, y=-2958.14, z=13.9451, scale = 0.9 },
	--{ title="Seaview Aircraft", colour = 60, id = 251, x=2119.083, y=4790.010, z=41.139, scale = 0.9 },
	--{ title="Meth", colour = 75, id = 499, x = 1389.28, y = 3604.6, z = 38.1 }, -- sandy shores ace liqour
	--{ title="Meth", colour = 75, id = 499, z = 42.3476, y = 4968.75,  x = 2434.47 }, -- grape seed meth lab house
	--{ title="Boat Shop", colour = 57, id = 356, x = -250.183, y = 6632.84, z = 1.79 }, -- paleto
	--{ title="Boat Shop", colour = 57, id = 356, x = 2388.26, y = 4284.28, z = 30.6 }, -- sandy
	--{ title="Boat Shop", colour = 57, id = 356, x = -782.1, y = -1441.0, z = 1.6 }, -- Los Santos
	--{ title="Boat Shop", colour = 57, id = 356,x = -193.3, y = 790.1, z = 198.1 }, -- Los Santos (small lake)
	{ title="Jail", colour = 4, id = 238, x=1686.668, y=2581.715, z=51.6 },
	--{ title="Watercraft Course", colour = 63, id = 38, x=2272.15, y=4321.29, z=39.8 },
	--{ title="Barber Shop", colour = 4, id = 71, x=-278.174, y=6226.93, z=51.6 },
	--{ title="Weed", colour = 2, id = 140, x = 2224.04, y = 5577.28, z = 52.7 },
	{ title="Courthouse", colour = 84, id = 475, scale = 0.7, x = 243.34686279297,y = -1073.7106933594, z = 29.285400390625 },
	--{ title="Burns Events Center", colour = 4, id = 354, x = 1228.009, y = 3642.315, z = 32.79 },
	{ title="Weazel News", colour = 4, id = 184, x = -249.6443, y = 6235.7524, z = 30.4893 },
	{ title="Weazel News", colour = 4, id = 184, x = -599.5, y = -931.9, z = 23.9 },
	{ title="Cluckin' Bell", colour = 4, id = 89, x = -69.9295, y = 6251.2900, z = 30.4893, scale = 0.7 },
	{ title="Vangelico", colour = 81, id = 478, x = -623.4, y = -233.1, z = 38.1, scale = 0.5 },
	{title = "Hunting", x = -1508.83, y = 4978.63, id = 442, colour = 0},
	{ title = "Burger Shot", x = -1189.22, y = -888.43, id = 106, colour = 1, scale = 0.7},
	--{ title = "REA Office", x = -148.55, y = -579.82, id = 475, colour = 2, scale = 0.7},
	{ title = "Mining", x = -596.51, y = 2090.44, id = 78, colour = 59, scale = 0.5},
	{ title = "Mining", x = 1797.88, y = -2831.8, id = 78, colour = 59, scale = 0.5},
	{ title = "Casino", x = 923.79486083984,y = 49.580528259277, id = 89, colour = 73, scale = 0.7},
	{ title = "Vishnu's Go-Karts", x = -58.797729492188, y = -1839.8370361328, id = 488, colour = 0, scale = 0.7}
}

Citizen.CreateThread(function()
    for _, info in pairs(blips) do
		info.blip = AddBlipForCoord(info.x, info.y, info.z)
		SetBlipSprite(info.blip, info.id)
		SetBlipDisplay(info.blip, 4)
		SetBlipScale(info.blip, info.scale or 0.8)
		SetBlipColour(info.blip, info.colour)
		SetBlipAsShortRange(info.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(info.title)
		EndTextCommandSetBlipName(info.blip)
    end
end)


function GetPlayers()
    local players = {}
    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, GetPlayerServerId(i))
        end
    end
    return players
end
