--# by: minipunch
--# for USA REALISM rp
--# This script keeps a server sided track of frozen states on objects like doors or gates that can be toggled by being in the activation area and pressing "E"

local DOORS = {
  {name = "Bolingbroke Prison Gate 1", x = 1818.662, y = 2606.8, z = 45.59, model = 741314661, locked = true, _dist = 8.0, gate = true, offset={0.0, 3.65, 2.8}, lockedCoords={1818.54, 2604.811, 44.607}, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Bolingbroke Prison Gate 2", x = 1845.05, y = 2607.21, z = 45.57, model = 741314661, locked = true, _dist = 8.0, gate = true, offset={0.0, 3.65, 2.8}, lockedCoords={1844.99, 2604.811, 44.636}, allowedJobs = {'sheriff', 'corrections', 'judge'}},

  {name = "Boilingbroke Visitors Reception", x = 1838.26, y = 2594.52, z = 45.95, model = -1033001619, locked = true, offset={0.0, -1.13, 0.05}, heading=270.0, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Inmate Processing", x = 1838.3, y = 2586.02, z = 45.95, model = -1033001619, locked = true, offset={0.0, -1.13, 0.05}, heading=90.0, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Inmate CO Door", x = 1828.57, y = 2585.2, z = 45.95, model = -1033001619, locked = true, offset={0.0, -1.13, 0.05}, heading=0.0, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Exterior Door", x = 1827.1, y = 2585.81, z = 45.95, model = -1033001619, locked = true, static = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Leading Into Yard", x = 1827.94, y = 2586.88, z = 45.95, model = -1033001619, locked = true, offset={0.0, -1.13, 0.05}, heading=0.0, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Leading Yard Gate 1", x = 1796.62, y = 2595.63, z = 45.8, model = -1156020871, locked = true, offset={0.0, -1.13, 0.05}, heading=180.0, _dist =3.0, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Leading Yard Gate 2", x = 1797.39, y = 2592.49, z = 45.8, model = -1156020871, locked = true, offset={0.0, -1.13, 0.05}, heading=180.0, _dist = 3.0, allowedJobs = {'sheriff', 'corrections', 'judge'}},

  {name = "Boilingbroke Pantry Door", x = 1784.59, y = 2598.43, z = 45.8, model = 1028191914, locked = true, offset={0.0, 1.13, 0.05}, heading=90.0, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Side Entrance", x = 1786.384, y = 2600.229, z = 46.089, model = 262839150, locked = true, offset={0.0, 1.13, 0.05}, heading=0, _dist = 2, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Side Entrance 2", x = 1791.18, y = 2552.05, z = 45.8, model = 262839150, locked = true, offset={0.0, 1.13, 0.05}, heading=270, _dist = 2, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Side Entrance 3", x = 1776.7, y = 2551.9, z = 45.8, model = 1645000677, locked = true, offset={0.0, 1.13, 0.05}, heading=270, _dist = 2, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Side Entrance 4", x = 1765.69, y = 2567.85, z = 45.71, model = 1645000677, locked = true, offset={0.0, 1.13, 0.05}, heading=0, _dist = 2, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Armory / offices", x = 1785.39, y = 2550.78, z = 45.8, model = 1028191914, locked = true, offset={0.0, 1.13, 0.05}, heading=180, _dist = 2, allowedJobs = {'sheriff', 'corrections', 'judge'}},

  {name = "Boilingbroke upper office small", x = 1785.72, y = 2551.02, z = 49.58, model = 1028191914, locked = true, offset={0.0, 1.13, 0.05}, heading=90, _dist = 2, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke upper office large left door", x = 1782.45, y = 2551.5, z = 49.58, model = 1028191914, locked = true, offset={0.0, 1.13, 0.05}, heading=90, static=true, _dist = 2, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke upper office large right door", x = 1782.24, y = 2552.58, z = 49.58, model = 1028191914, locked = true, offset={0.0, 1.13, 0.05}, heading=90, _dist = 2, allowedJobs = {'sheriff', 'corrections', 'judge'}},

  {name = "Boilingbroke Solitary MAIN", x = 1768.2, y = 2606.66, z = 50.55, model = 430324891, locked = true, static = true, offset={0.0, 1.13, 0.05}, heading=90, _dist = 2, allowedJobs = {'sheriff', 'corrections', 'judge'}},


  {name = "Boilingbroke gate 1", x = 1556.83, y = 2474.11, z = 45.4, model = 3596913592, static = true, locked = true, offset={0.0, 1.13, 0.05}, heading=0, _dist = 2, allowedJobs = {'sheriff', 'corrections', 'judge'}},

  {name = "Bolingbroke Cellblock Entry 1", x = 1790.5031738281,y = 2594.3981933594, z = 45.797847747803, model = 1645000677, locked = true, static = true, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Bolingbroke Cellblock Entry 2", x = 1790.5510253906,y = 2593.14453125, z = 45.800338745117, model = 262839150, locked = true, offset={0.0, 1.24, 0.0}, heading=270, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},

  {name = "Boilingbroke Main Cell Block Area", x = 1786.7034912109,y = 2590.3452148438, z = 45.797817230225, model = 430324891,  customDoor = { coords = {x = 1787.2597167969, y = 2589.5066210938, z = 44.797801971436}, model = GetHashKey("prop_ld_jail_door"), rot = -21.0}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Gym Cell Door", x = 1774.0618896484,y = 2589.5766601563, z = 45.7978515625, model = 430324891,  customDoor = { coords = {x = 1774.3618896484,y = 2590.43766601563, z = 44.7978515625}, model = GetHashKey("prop_ld_jail_door"), rot = 32.0}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Lower Cell 1", x = 1786.35, y = 2586.55, z = 45.8, model = 430324891, customDoor = { coords = {x = 1787.6, y = 2585.6, z = 44.8}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},  
  {name = "Boilingbroke Lower Cell 2", x = 1786.44, y = 2582.59, z = 45.8, model = 430324891, customDoor = { coords = {x = 1787.6274414063, y = 2581.6008300781, z = 44.8}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Lower Cell 3", x = 1786.95, y = 2578.53, z = 45.8, model = 430324891, customDoor = { coords = {x = 1787.5969482422, y = 2577.683515625, z = 44.797801971436}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Lower Cell 4", x = 1787.09, y = 2574.81, z = 45.8, model = 430324891, customDoor = { coords = {x = 1787.6362304688, y = 2573.9124023438, z = 44.797801971436}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Lower Cell 5", x = 1771.99, y = 2573.78, z = 45.8, model = 430324891, customDoor = { coords = {x = 1771.6436767578, y = 2572.6249511719, z = 44.797798156738}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Lower Cell 6", x = 1772.85, y = 2577.49, z = 45.8, model = 430324891, customDoor = { coords = {x = 1771.7103515625, y = 2576.6262207031, z = 44.797798156738}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Lower Cell 7", x = 1773.03, y = 2581.19, z = 45.8, model = 430324891, customDoor = { coords = {x = 1771.6531982422, y = 2580.4447753906, z = 44.797798156738}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Lower Cell 8", x = 1772.15, y = 2585.26, z = 45.8, model = 430324891, customDoor = { coords = {x = 1771.6440429688, y = 2584.5698242188, z = 44.797798156738}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 1", x = 1785.196, y = 2600.171, z = 49.5481, model = 430324891, customDoor = { coords = {x = 1786.0, y = 2600.0498046875, z = 49.549644470215}, model = GetHashKey("prop_ld_jail_door"), rot = 0.0}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 2", x = 1787.01, y = 2598.22, z = 50.55, model = 430324891,  customDoor = { coords = {x = 1787.5437744141, y = 2597.5242675781, z = 49.549640655518}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 1, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 3", x = 1787.552, y = 2593.33, z = 50.55, model = 430324891,  customDoor = { coords = {x = 1787.4525878906, y = 2593.454296875, z = 49.54963684082}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 4", x = 1787.567, y = 2589.679, z = 50.55, model = 430324891,  customDoor = { coords = {x = 1787.6911621094, y = 2589.587109375, z = 49.549648284912}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true,allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 6", x = 1787.576, y = 2585.726, z = 50.55, model = 430324891,  customDoor = { coords = {x = 1787.6639404297, y = 2585.6537597656, z = 49.549640655518}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 7", x = 1787.578, y = 2581.756, z = 50.55, model = 430324891,  customDoor = { coords = {x = 1787.5763671875, y = 2581.7619628906, z = 49.549640655518}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 8", x = 1787.579, y = 2577.85, z = 50.55, model = 430324891,  customDoor = { coords = {x = 1787.66796875, y = 2577.7236816406, z = 49.549648284912}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 9", x = 1787.578, y = 2573.937, z = 50.55, model = 430324891,  customDoor = { coords = {x = 1787.5822265625, y = 2573.8324707031, z = 49.549648284912}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 10", x = 1786.427, y = 2570.487, z = 50.55, model = 430324891,  customDoor = { coords = {x = 1787.1133544922, y = 2570.0577246094, z = 49.549648284912}, model = GetHashKey("prop_ld_jail_door"), rot = 0.0}, locked = true, _dist = 1, cell_block = true,  allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 11", x = 1781.727, y = 2570.058, z = 50.55, model = 430324891,  customDoor = { coords = {x = 1783.1546875, y = 2569.94140625, z = 49.549659729004}, model = GetHashKey("prop_ld_jail_door"), rot = 0.0}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 13", x = 1777.825, y = 2570.058, z = 50.55, model = 430324891,  customDoor = { coords = {x = 1779.2388427734, y = 2569.9523925781, z = 49.549663543701}, model = GetHashKey("prop_ld_jail_door"), rot = 0.0}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 14", x = 1773.908, y = 2570.058, z = 50.55, model = 430324891,  customDoor = { coords = {x = 1775.2550244141, y = 2570.0477539063, z = 49.549663543701}, model = GetHashKey("prop_ld_jail_door"), rot = 0.0}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Blank Door For Now", x = 1772.09, y = 2571.03, z = 50.55, model = 1028191914, locked = true, _dist = 2, static = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 15", x = 1771.652, y = 2574.116, z = 50.55, model = 430324891,  customDoor = { coords = {x = 1771.5736083984, y = 2572.7112304688, z = 49.549663543701}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 16", x = 1771.651, y = 2578.026, z = 50.55, model = 430324891,  customDoor = { coords = {x = 1771.5819091797, y = 2576.6306640625, z = 49.549663543701}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 17", x = 1771.649, y = 2581.935, z = 50.55, model = 430324891,  customDoor = { coords = {x = 1771.7013720703, y = 2580.5034667969, z = 49.549663543701}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 18", x = 1771.65, y = 2585.913, z = 50.55, model = 430324891,  customDoor = { coords = {x = 1771.5804443359, y = 2584.5664550781, z = 49.549663543701}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 19", x = 1771.725, y = 2589.854, z = 50.55, model = 430324891,  customDoor = { coords = {x = 1771.6334228516, y = 2588.3707519531, z = 49.549663543701}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true,  allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 20", x = 1771.724, y = 2593.782, z = 50.55, model = 430324891,  customDoor = { coords = {x = 1771.6627441406, y = 2592.4473144531, z = 49.549663543701}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true,  allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 21", x = 1771.725, y = 2597.737, z = 50.55, model = 430324891,  customDoor = { coords = {x = 1771.6867919922, y = 2596.2808105469, z = 49.549640655518}, model = GetHashKey("prop_ld_jail_door")}, locked = true, _dist = 2, cell_block = true,  allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Upper Cell 22", x = 1773.654, y = 2599.994, z = 50.55, model = 430324891, locked = true, _dist = 2, static = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "CO Bird Cage", x = 1780.352, y = 2596.023, z = 50.55, model = 1028191914, locked = true, _dist = 2, offset={1.13, 2.20, 0.05}, heading=0,  allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Solitary Double Doors", x = 1780.15, y = 2600.77, z = 50.55, model = 1028191914, static= true, locked = true, _dist = 2, offset={1.13, 2.20, 0.05}, heading=0,  allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Solitary Double Doors", x = 1778.74, y = 2601.03, z = 50.55, model = 1028191914, locked = true, _dist = 2, offset={1.13, 0.00, 0.05}, heading=180,  allowedJobs = {'sheriff', 'corrections', 'judge'}},

  {name = "Boilingbroke medic door left", x = 1783.93, y = 2557.73, z = 45.8, model = 580361003, static= true, locked = true, _dist = 2, offset={1.13, 2.20, 0.05}, heading=0,  allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke medic door right", x = 1783.51, y = 2558.79, z = 45.8, model = 580361003, locked = true, _dist = 2, offset={0, 1.20, 0.05}, heading=88,  allowedJobs = {'sheriff', 'corrections', 'judge'}},

  {name = "Boilingbroke Cell Block Side 1", x = 1785.1411132813,y = 2571.6547851563, z = 45.797821044922, model = 430324891,  customDoor = { coords = {x = 1786.0126464844, y = 2571.9845214844, z = 44.797840118408}, model = GetHashKey("prop_ld_jail_door"), rot = 0.0}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Boilingbroke Cell Block Side 2", x = 1772.9583740234,y = 2571.7209472656, z = 45.797840118408, model = 430324891,  customDoor = { coords = {x = 1773.8320068359, y = 2571.9602050781, z = 44.797840118408}, model = GetHashKey("prop_ld_jail_door"), rot = 0.0}, locked = true, _dist = 2, cell_block = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},

  {name = "Lower Visitation Left", x = 1785.18, y = 2609.17, z = 45.92, model = 262839150, static= true, locked = true, _dist = 2, offset={1.13, 2.20, 0.05}, heading=0,  allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Lower Visitation Right", x = 1786.5, y = 2609.21, z = 45.92, model = 1645000677, locked = true, _dist = 2, offset={0.00, 1.20, 0.05}, heading=0,  allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Door 332 #1 EXT", x = 1786.27, y = 2621.52, z = 45.92, model = 262839150, locked = true, _dist = 2, offset={0.00, 1.20, 0.05}, heading=0,  allowedJobs = {'sheriff', 'corrections', 'judge'}},

  {name = "Upper Visitation door", x = 1787.21, y = 2606.77, z = 50.55, model = 1028191914, locked = true, _dist = 2, offset={0.00, 1.20, 0.05}, heading=270,  allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Visitation Lower Left", x = 1782.43, y = 2614.14, z = 45.14, model = 1028191914, locked = true, _dist = 2, offset={0.00, 1.20, 0.05}, heading=270,  allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Visitation Lower Right", x = 1782.34, y = 2618.58, z = 45.14, model = 1028191914, locked = true, _dist = 2, offset={0.00, 1.20, 0.05}, heading=90,  allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Visitation Bedroom", x = 1768.61, y = 2614.28, z = 45.97, model = 1028191914, locked = true, _dist = 2, offset={0.00, 1.20, 0.05}, heading=270,  allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Visitation Bedroom Door 2", x = 1766.42, y = 2614.9, z = 46.0, model = 1028191914, locked = true, _dist = 2, offset={0.00, 1.20, 0.05}, heading=0,  allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Visitation Door to bedroom", x = 1768.69, y = 2618.57, z = 45.97, model = 1028191914, locked = true, _dist = 2, offset={0.00, 1.20, 0.05}, heading=90,  allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Door 332 EXT", x = 1753.3, y = 2615.56, z = 45.56, model = 1645000677, static = true, locked = true, _dist = 2, offset={0.00, 1.20, 0.05}, heading=0,  allowedJobs = {'sheriff', 'corrections', 'judge'}},

  {name = "Yard Door", x = 1763.97, y = 2616.71, z = 45.97, model = 1028191914, locked = true, _dist = 2, offset={0.00, 1.20, 0.05}, heading=90,  allowedJobs = {'sheriff', 'corrections', 'judge'}},



  {name = "Mission Row / Door 1", x = 464.192, y = -1003.638, z = 24.9, model = -1033001619, locked = true, offset={0.0, -1.13, 0.05}, heading=0, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Door 2", x = 463.72, y = -992.7, z = 24.9, model = 631614199, locked = true, offset={0.0, 1.12, 0.025}, heading=0, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Cell 1", x = 461.7, y = -993.6, z = 24.9, model = 631614199, locked = false, offset={0.0, 1.12, 0.025}, heading=270, _dist = 1.5, allowedJobs = {'sheriff','corrections'}},
  {name = "Mission Row / Cell 2", x = 462.75, y = -998.3, z = 24.9, model = 631614199, locked = false, offset={0.0, 1.12, 0.025}, heading=90, _dist = 1.5, allowedJobs = {'sheriff','corrections'}},
  {name = "Mission Row / Cell 3", x = 462.7, y = -1001.9, z = 24.9, model = 631614199, locked = false, offset={0.0, 1.12, 0.025}, heading=90, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Lower Entry 1", x = 463.57867431641,y = -1004.1882324219, z = 24.914945602417, model = 185711165, locked = true, static = true, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Lower Entry 2", x = 464.4914855957,y = -1004.1607055664, z = 24.914945602417, model = 185711165, locked = false, offset={0.0, 1.24, 0.0}, heading=0, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Office", x = 447.3,  y = -980.4, z = 30.7, model = -1320876379, locked = true, offset={0.0, 1.15, -0.1}, heading=180, _dist = 1.0, allowedJobs = {'sheriff'}},
  {name = "Mission Row / Aux 1", x = 466.12319946289,y = -990.48913574219, z = 24.914930343628, model = 185711165, locked = true, static = true, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Aux 2", x = 466.26898193359,y = -989.31799316406, z = 24.914930343628, model = 185711165, locked = false, offset={0.0, 1.24, 0.0}, heading=90, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "EMS Station - Paleto", x = -361.8, y = 6129.8, z = 31.4, model = -250842784, locked = false, _dist = 1.5, allowedJobs = {'ems'}},
  {name = "Mission Row / Roof", x = 463.58, y = -983.94, z =43.69, model = -340230128, locked = true, offset={0.0, -1.05, 0.10}, heading=89, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Roof", x = 463.58, y = -983.94, z =43.69, model = -340230128, locked = true, offset={0.0, -1.05, 0.10}, heading=89, _dist = 2, allowedJobs = {'sheriff', 'corrections', 'judge'}},

  {name = "Mission Row / Holding Cells Entrance 1", x = 468.1, y = -1014.3299, z = 26.4, model = -2023754432, locked = true, offset={0.0, -1.12, 0.0}, heading=0, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Holding Cells Entrance 2", x = 469.3, y = -1014.4, z = 26.4, model = -2023754432, locked = true, static = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Back Gate", x = 488.90, y = -1019.88, z = 28.21, model = -1603817716, locked = true, _dist = 8.0, gate = true, offset={0.0, -3.0, 1.5}, lockedCoords={488.89, -1017.35, 27.14}, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Cells Door 1", x = 443.9, y = -988.6, z = 30.7, model = 185711165, locked = true, static = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Cells Door 2", x = 445.22, y = -989.4, z = 30.7, model = 185711165, locked = true, offset={0.0, 1.24, 0.0}, heading=0, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Side Room 1", x = 443.7, y = -992.4, z = 30.7, model = -131296141, locked = true, static = true, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Side Room 2", x = 443.6, y = -993.9, z = 30.7, model = -131296141, locked = true, offset={0.0, 1.24, 0.0}, heading=270, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = 'Mission Row / Meeting Room 1',  x = 469.21,y = -1009.67, z = 26.39, model = -543497392, locked = true, offset={0.0, 1.05, 0.3}, heading = 89, _dist = 1.5, allowedJobs = {'sheriff', "corrections"}},
  {name = "Mission Row / Meeting Room 2", x = 469.44,y = -1010.97, z = 26.39, model = -543497392, locked = true, static = true, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Solitary 1", x = 467.75,y = -996.86, z = 24.91, model = -1033001619, locked = true, offset={0.0, -1.05, 0.3}, heading = 358, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Solitary 2", x = 472.22,y = -996.62, z = 24.91, model = -1033001619, locked = true, offset={0.0, -1.05, 0.3}, heading = 358, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Solitary 2", x = 476.43,y = -997.01, z = 24.91, model = -1033001619, locked = true, offset={0.0, -1.05, 0.3}, heading = 358, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Solitary 3", x = 480.76,y = -997.01, z = 24.1, model = -1033001619, locked = true, offset={0.0, -1.05, 0.3}, heading = 358, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Interview Room 1", x = 480.74,y = -1002.8, z = 24.91, model = -1033001619, locked = true, offset={0.0, -1.05, 0.3}, heading = 358, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Interview Room 2", x = 476.65,y = -1002.93, z = 24.91, model = -1033001619, locked = true, offset={0.0, -1.05, 0.3}, heading = 178, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Interview Room 3", x = 472.1,y = -1002.98, z = 24.91, model = -1033001619, locked = true, offset={0.0, -1.05, 0.3}, heading = 0, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Interview Room 4", x = 467.55,y = -1002.48, z = 24.91, model = -1033001619, locked = true, offset={0.0, -1.05, 0.3}, heading = 181, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Storage / Evidence", x = 470.84,y = -985.25, z = 24.91, model = -131296141, locked = true, offset={0.0, 1.05, 0.3}, heading = 268, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Offices Double Doors 1", x = 464.99,y = -989.55, z = 24.91, model = -543497392, locked = true, offset={0.0, 1.05, 0.3}, heading = 90, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Offices Double Doors 2", x = 464.97,y = -991.0, z = 24.91, model = -543497392, locked = true, static=true, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Offices Double Doors(2) 1", x = 451.68,y = -984.83, z = 26.67, model = -543497392, locked = true, offset={0.0, 1.05, 0.3}, heading = 180, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Offices Double Doors(2) 2", x = 453.07,y = -984.49, z = 26.67, model = -543497392, locked = true, static=true, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Dispatch 1", x = 446.58,y = -987.2, z = 26.67, model = -543497392, locked = true, offset={0.0, 1.05, 0.3}, heading = 270, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Dispatch 2", x = 446.82,y = -985.52, z = 26.67, model = -543497392, locked = true, static=true, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Garage 1", x = 446.44,y = -998.28, z = 30.69, model = -1033001619, locked = true, offset={0.0, -1.05, 0.3}, heading = 180, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Garage 2", x = 445.33,y = -998.04, z = 30.69, model = -1033001619, locked = true, static=true, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Balcony Rear", x = 463.53,y = -1010.7, z = 32.99, model = 507213820, locked = true, offset={0.0, 1.05, 0.3}, heading = 358, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Locker Room / Canteen 1", x = 460.22,y = -990.0, z = 30.69, model = -131296141, locked = true, offset={0.0, 1.05, 0.3}, heading = 90, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Locker Room / Canteen 2", x = 460.23,y = -991.47, z = 30.69, model = -131296141, locked = true, static=true, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Mission Row / Ground Stairs", x = 460.29,y = -986.19, z = 30.69, model = 749848321, locked = true, offset={0.0, 1.05, 0.3}, heading = 88, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},

  --{name = "BCSO Station Gate - Paleto", model = -1483471451, locked = false, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "BCSO Station - Sidewalk", x = -449.8, y = 6024.3, z = 31.5, model = -1156020871, locked = true, offset={0.0, -1.5, -0.095}, heading=315, _dist = 1.0, allowedJobs = {'sheriff', "corrections"}},
  {name = "BCSO Station - Sandy Shores", x = 1855.0, y = 3683.5, z = 34.2, model = -1765048490, locked = false, offset={0.0, 1.24, -0.1}, heading=30, _dist = 1.0, allowedJobs = {'sheriff', "corrections"}},
  {name = "BCSO Station - Cell 1", x = -432.09231567383, y = 5999.8515625, z = 31.716178894043, model = 631614199, locked = false, offset={0.0, 1.24, -0.1}, heading=315, _dist = 1.0, allowedJobs = {'sheriff', "corrections"}},
  {name = "BCSO Station - Cell 2", x = -429.02087402344,y = 5996.828125, z = 31.716180801392, model = 631614199, locked = false, offset={0.0, 1.24, -0.1}, heading=315, _dist = 1.0, allowedJobs = {'sheriff', "corrections"}},
  {name = "BCSO Station - Questioning", x = -453.81491088867,y = 6010.7387695313, z = 31.716337203979, model = -519068795, locked = false, offset={0.0, -1.0, -0.1}, heading=10, _dist = 1.0, allowedJobs = {'sheriff', "corrections"}},
  --{name = "Prison Block / Cell 1", x = 1729.7, y = 2624.0, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 2", x = 1729.8, y = 2628.1, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 3", x = 1730.1, y = 2632.3, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 4", x = 1729.9, y = 2636.4, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 5", x = 1730.0, y = 2640.5, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 6", x = 1729.8, y = 2644.5, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 7", x = 1729.9, y = 2648.6, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 8", x = 1743.3, y = 2631.6, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 9", x = 1743.5, y = 2635.9, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 10", x = 1743.1, y = 2639.8, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 11", x = 1743.0, y = 2644.0, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 12", x = 1743.4, y = 2648.0, z = 45.6, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 13", x = 1729.4, y = 2624.13, z = 49.25, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 14", x = 1729.4, y = 2628.07, z = 49.29, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 15", x = 1729.4, y = 2632.43, z = 49.27, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 16", x = 1729.4, y = 2636.39, z = 49.27, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 17", x = 1729.4, y = 2640.65, z = 49.28, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 18", x = 1729.4, y = 2644.57, z = 49.27, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 19", x = 1729.4, y = 2648.07, z = 49.27, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 20", x = 1743.8, y = 2623.47, z = 49.25, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 21", x = 1743.8, y = 2627.50, z = 49.26, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 22", x = 1743.8, y = 2631.81, z = 49.26, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 23", x = 1743.8, y = 2635.90, z = 49.27, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 24", x = 1743.8, y = 2639.50, z = 49.28, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 25", x = 1743.8, y = 2643.50, z = 49.28, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 26", x = 1743.8, y = 2647.50, z = 49.26, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 27", x = 1729.4, y = 2624.50, z = 53.06, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 28", x = 1729.4, y = 2628.10, z = 53.06, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 29", x = 1729.4, y = 2632.50, z = 53.07, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 30", x = 1729.4, y = 2636.50, z = 53.07, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 31", x = 1729.4, y = 2640.50, z = 53.08, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 32", x = 1729.4, y = 2644.50, z = 53.08, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 33", x = 1729.4, y = 2648.50, z = 53.09, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 34", x = 1743.8, y = 2623.60, z = 53.07, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 35", x = 1743.8, y = 2627.60, z = 53.08, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 36", x = 1743.8, y = 2631.70, z = 53.08, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 37", x = 1743.8, y = 2635.70, z = 53.08, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 38", x = 1743.8, y = 2639.80, z = 53.09, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 39", x = 1743.8, y = 2643.80, z = 53.09, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  --{name = "Prison Block / Cell 40", x = 1743.8, y = 2647.95, z = 53.10, model = -642608865, locked = true, cell_block = true, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "SSPD / Door 1", x = 1851.1119384766,y = 3683.1423339844, z = 34.286640167236, model = 1557126584, locked = false, offset={0.0, 1.24, 0.0}, heading=120, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', "ems"}},
  {name = "SSPD / Cell 1", x = 1848.771484375,y = 3681.3623046875, z = 34.286636352539, model = 631614199, locked = false, offset={0.0, 1.24, 0.0}, heading=120, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', "ems"}},
  {name = "SSPD / Cell 2", x = 1846.3103027344,y = 3685.2182617188, z = 34.286636352539, model = 631614199, locked = false, offset={0.0, 1.24, 0.0}, heading=300, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', "ems"}},
  {name = "SSPD / Door 2", x = 1845.7978515625,y = 3688.4809570313, z = 34.286602020264, model = 1557126584, locked = false, offset={0.0, 1.24, 0.0}, heading=30, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', "ems"}},
  {name = "SSPD / Door 3", x = 1843.3763427734,y = 3691.2065429688, z = 34.286617279053, model = 1557126584, locked = false, offset={0.0, 1.24, 0.0}, heading=300, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', "ems"}},
  {name = "SSPD / Door 4", x = 1849.0443115234,y = 3690.3146972656, z = 34.286636352539, model = 1557126584, locked = false, offset={0.0, 1.24, 0.0}, heading=25, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', "ems"}},
  {name = "SSPD / Door 5", x = 1850.6782226563,y = 3693.7448730469, z = 34.286636352539, model = 1557126584, locked = false, offset={0.0, 1.24, 0.0}, heading=120, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', "ems"}},
  {name = "SSPD / Door 6", x = 1854.0256347656,y = 3694.3923339844, z = 34.286655426025, model = 1557126584, locked = false, offset={0.0, 1.24, 0.0}, heading=30, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', "ems"}},
  {name = "SSPD / Door 7", x = 1856.3859863281,y = 3690.396484375, z = 34.286685943604, model = 1557126584, locked = false, offset={0.0, 1.24, 0.0}, heading=30, _dist = 1.0, allowedJobs = {'sheriff', 'corrections', "ems"}},
  {name = 'Hospital / Ward A 1', x = 303.23297119141,y = -582.19818115234, z = 43.284023284912, model = -434783486, locked = false, offset={0.0, -1.0, 0.00}, heading = 340, _dist = 1.5, allowedJobs = {'ems', 'sheriff', 'doctor', "corrections"}},
  {name = 'Hospital / Ward A 2', x = 304.57992553711,y = -582.55187988281, z = 43.284008026123, model = -1700911976, locked = true, static = true,  _dist = 1.5, allowedJobs = {'ems', 'sheriff', 'doctor', "corrections"}},
  {name = 'Hospital / Ward A 3', x = 326.43518066406,y = -579.94946289063, z = 43.284027099609, model = -1700911976, locked = false, offset={0.0, 1.0, 0.00}, heading = 250, _dist = 1.5, allowedJobs = {'ems', 'sheriff', 'doctor', "corrections"}},
  {name = 'Hospital / Ward A 4', x = 326.91903686523,y = -578.595703125, z = 43.284027099609, model = -434783486, locked = true, static = true,  _dist = 1.5, allowedJobs = {'ems', 'sheriff', 'doctor', "corrections"}},
  {name = 'BCSO Paleto - Door 1', x = -443.16, y = 6015.41, z = 31.71, model = -1501157055, locked = false, offset={0.0, 1.24, -0.1}, heading = 315, _dist = 1.5, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = 'BCSO Paleto - Door 2', x = -444.3, y = 6016.3, z = 31.71, model = -1501157055, locked = true, _dist = 1.5, static = true, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = 'Nightclub / Door 1', x = -1621.88, y = -3016.0, z = -75.20, model = -1119680854, locked = true, static = true, _dist = 1.0},
  {name = 'Nightclub / Door 2', x = -1621.15, y = -3019.06, z = -75.20, model = 1695461688, locked = true, static = true, _dist = 1.0},
  {name = 'Nightclub / Door 3', x = -1610.8, y = -3004.98, z = -79.0, model = 1743859485, locked = true, static = true, _dist = 1.0},
  {name = 'Legal Offices / Door 1', x = 121.21, y = -757.02, z = 242.15, model = -1821777087, locked = true, static = true, _dist = 1.0},
  {name = 'Legal Offices / Door 2', x = 143.16, y = -759.65, z = 242.15, model = -1821777087, locked = true, static = true, _dist = 1.0},
  {name = 'LSSD Davis / Door 1', x = 392.31, y = -1635.45, z = 29.29, model = -1156020871, locked = true, offset={0.0, -1.6, -0.1}, heading = 50, _dist = 1.0, allowedJobs = {'sheriff'}},
  {name = 'LSSD Davis / Gate 1', x = 398.32, y = -1607.73, z = 29.29, model = 1286535678, locked = true, _dist = 8.0, gate = true, offset={3.0, -2.5, 1.5}, lockedCoords = {397.88, -1607.38, 28.33}, allowedJobs = {'sheriff'}},
  {name = 'Mission Row / Front Gate', x = 411.4, y = -1028.26, z = 29.39, model = -512634970, locked = true, _dist = 10.0, gate = true, offset={0.0, 3.0, 1.5}, lockedCoords = {410.80, -1028.15, 28.38}, allowedJobs = {'sheriff', 'corrections', 'judge'}},
  {name = "Mission Row / Garage Door", x = 427.42, y = -1016.92, z = 28.97, model = 631614199, locked = true, offset={0.0, 1.12, 0.025}, heading=81, _dist = 1.0, allowedJobs = {'sheriff','corrections'}},
  {name = "Eclipse Towers / Heist Room", x = -767.55, y = 331.14, z = 211.39, model = 34120519, locked = true, static = true, _dist = 1.0},
  {name = "DA Office / Door 1", x = -74.45, y = -821.88, z = 243.38, model = 220394186, locked = true, offset = {0.0, 0.7, 0.05}, heading = 340.0, _dist = 1.0, allowedJobs = {'da', 'judge'}},
  {name = "DA Office / Door 2", x = -75.15, y = -821.65, z = 243.38, model = 220394186, locked = true, static = true, _dist = 1.0},
  {name = "DA Office / Door 3", x = -77.35, y = -808.07, z = 243.38, model = -88942360, locked = true, offset = {0.0, 1.12, -0.02}, heading = 340.0, _dist = 1.0, allowedJobs = {'da', 'judge'}},
  {name = "DA Office / Door 4", x = -77.79, y = -814.25, z = 243.38, model = -88942360, locked = true, offset = {0.0, 1.12, -0.02}, heading = 250.0, _dist = 1.0, allowedJobs = {'da', 'judge'}},
  {name = "Court House / Front 1", x = 242.60382080078,y = -1074.208984375, z = 29.287979125977, model = 110411286, locked = true, static = true, _dist = 1.0, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Court House / Front 2", x = 243.99006652832,y = -1074.3812255859, z = 29.286693572998, model = 110411286, locked = false, offset={0.0, -1.24, 0.0}, heading=180, _dist = 1.5, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Jewellery Store Door 1", x = -631.91,y = -237.19, z = 38.06, model = 1425919976, locked = true, thermiteable = true, offset={0.0, -0.8, 0.0}, heading=305.0, _dist = 1.0, allowedJobs = {'sheriff', "corrections", "ems", "judge"}},
  {name = "Jewellery Store Door 2", x = -631.15,y = -238.21, z = 38.09, model = 9467943, locked = true, static = true, _dist = 1.0},
  --Bank stuff with new pick method
  {name = "Pacific Standard Bank / Door 1", x = 261.96, y = 221.79, z= 106.28, model = 746855201, locked = true, offset ={0.0, -1.2, 0.0}, heading = 250.0, _dist = 1.0, advancedlockpickable = true, allowedJobs = {'sheriff', 'corrections'}},
  {name = "Pacific Standard Bank / Door 2", x = 256.89, y = 220.34, z = 106.28, model = -222270721, locked = true, offset ={0.0, -1.2, 0.0}, heading = 340.0, _dist = 1.0, advancedlockpickable = true, allowedJobs = {'sheriff', 'corrections'}},
  {name = "Pacific Standard Bank / Door 3", x = 256.76, y = 206.78, z = 110.28, model = 1956494919, locked = true, offset ={0.0, 1.25, -0.2}, heading = 250.0, _dist = 1.0, advancedlockpickable = true, allowedJobs = {'sheriff', 'corrections'}},
  {name = "Pacific Standard Bank / Vault Door 1", x = 252.74, y = 221.24, z = 101.68, model = -1508355822, locked = true, offset ={0.0, 1.25, -0.2}, heading = 160.0, _dist = 1.0, advancedlockpickable = true, allowedJobs = {'sheriff', 'corrections'}},
  {name = "Pacific Standard Bank / Vault Door 2", x = 261.14, y = 215.32, z = 101.68, model = -1508355822, locked = true, offset ={0.0, 1.25, -0.2}, heading = 250.0, _dist = 1.0, advancedlockpickable = true, allowedJobs = {'sheriff', 'corrections'}},

  {name = "Legion Door 1", x = 147.37, y = -1045.01, z = 29.37, model = -1591004109, locked = true, offset ={0.0, -1.5, 0.0}, heading = 250.0, _dist = 1.0, advancedlockpickable = true, allowedJobs = {'sheriff', "corrections"}},
  {name = "Legion Door 2", x = 149.75, y = -1046.92, z = 29.35, model = -1591004109, locked = true, offset ={0.0, -1.5, 0.0}, heading = 160.0, _dist = 1.0, advancedlockpickable = true, allowedJobs = {'sheriff', "corrections"}},
  {name = "Harmony Door 1", x = 1175.8, y = 2711.88, z = 38.09, model = -1591004109, locked = true, offset ={0.0, -1.5, 0.0}, heading = 90.0, _dist = 1.0, advancedlockpickable = true, allowedJobs = {'sheriff', "corrections"}},
  {name = "Harmony Door 2", x = 1173.16, y = 2712.46, z = 38.07, model = -1591004109, locked = true, offset ={0.0, -1.5, 0.0}, heading = 0.0, _dist = 1.0, advancedlockpickable = true, allowedJobs = {'sheriff', "corrections"}},
  {name = "Paleto Bank 1", x = -106.34, y = 6475.35, z = 31.63, model = 1309269072, locked = true, offset ={0.0, -1.0, -0.2}, heading = 310.0, _dist = 1.0, advancedlockpickable = true, allowedJobs = {'sheriff', "corrections"}},
  {name = "Paleto Bank 2", x = -105.8, y = 6473.4, z = 31.63, model = 1622278560, locked = true, offset ={0.0, 1.0, -0.2}, heading = 41.0, _dist = 1.0, advancedlockpickable = true, allowedJobs = {'sheriff', "corrections"}},
}

-- allowedJobs - table of job names allowed to use door, the player's job must match any value in the list for the door to lock/unlock
-- offsetX, offsetY, offsetZ - 3D text offset from the object's coordinates (used to display text)
-- static - true will result in the door being left in the state defined (locked/unlocked), and will prevent text from displaying for locking/unlocking (used to lock one of two double doors permanently)
-- _dist - distance which needs to be met before the door can be locked/unlocked
-- heading - the heading of the door in it's regular position (when a player is not holding it open) -- this value should always be somewhat a multiple of 5 as rockstar like uniformity e.g., 270, 90, 180, 30, 315
-- ymap - true will result in the door not using any of the above new values for 3D text, and having the text display at the x, y, z coords on the list

RegisterServerEvent("doormanager:checkDoorLock")
AddEventHandler("doormanager:checkDoorLock", function(index, x, y, z, lockpicked, thermited)
  local char = exports["usa-characters"]:GetCharacter(source)
  local job = char.get("job")
  local da_rank = char.get('daRank')
  for i = 1, #DOORS[index].allowedJobs do
    if job == DOORS[index].allowedJobs[i] or (lockpicked and DOORS[index].lockpickable) or (DOORS[index].allowedJobs[i] == 'da' and da_rank and da_rank > 0) or (lockpicked and DOORS[index].advancedlockpickable) or (thermited and DOORS[index].thermiteable) then
        if not DOORS[index].locked then
          DOORS[index].locked = true
        else
          DOORS[index].locked = false
        end
        TriggerClientEvent("doormanager:toggleDoorLock", -1, index, DOORS[index].locked, x, y, z)
        break
    end
  end
end)

RegisterServerEvent('doormanager:lockThermitableDoors')
AddEventHandler('doormanager:lockThermitableDoors', function()
  for i = 1, #DOORS do
    if DOORS[i].thermiteable then
      DOORS[i].locked = true
      TriggerClientEvent("doormanager:toggleDoorLock", -1, i, DOORS[i].locked, DOORS[i].x, DOORS[i].y, DOORS[i].z)
    end
  end
end)

RegisterServerEvent("doormanager:firstJoin")
AddEventHandler("doormanager:firstJoin", function()
  TriggerClientEvent("doormanager:update", source, DOORS)
end)

TriggerEvent('es:addGroupCommand', 'lockdebug', 'owner', function(source, args, char)
  TriggerClientEvent("doormanager:debug", source)
end, {
	help = "DEBUG: Debug the door lock system"
})

