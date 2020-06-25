--
-- Constants
--

CONST_NOTWORKING     = 0
CONST_WAITINGFORTASK = 1
CONST_PICKINGUP      = 2
CONST_DELIVERING     = 3

--
-- Configuration
--

Config = {}

Config.AbortKey         = 167 -- (F6)
Config.TruckRentalPrice = 1000
Config.TruckModel       = 'phantom'
Config.PayPerMeter      = 0.25

Config.JobStart = {
	Coordinates = vector3(1189.61, -3104.31, 4.7),
	Heading     = 0.0,
	VehicleSpawn = {
		Coordinates = vector3(1203.2883300781, -3098.3369140625, 5.8406972885132),
		Heading = 85.0
	}
}

Config.Blip = {
	SpriteID = 477,
	ColorID  = 31,
	Scale    = 0.9,
}

Config.Marker = {
	DrawDistance = 100.0,
	Size = vector3(3.0, 3.0, 1.0),
	Color = {
		r = 102,
		g = 102,
		b = 204,
	},
	Type = 1,
}

Config.Routes = {
	{
		TrailerModel      = 'tr4',
		PickupLocations = {
			{
				coords = vector3(508.94, -3047.27, 6.32),
				heading = 0.0
			},
			{
				coords = vector3(528.59619140625, -3045.0373535156, 6.0696315765381),
				heading = 90.0
			},
			{
				coords = vector3(558.90783691406, -3022.5249023438, 6.0125379562378),
				heading = 270.0
			},
			{
				coords = vector3(540.05407714844, -3022.4138183594, 6.0193433761597),
				heading = 270.0
			},
			{
				coords = vector3(518.72143554688, -3022.5971679688, 6.0006294250488),
				heading = 270.0
			},
			{
				coords = vector3(504.80932617188, -3022.2158203125, 6.0026593208313),
				heading = 270.0
			},
			{
				coords = vector3(577.11224365234, -3029.08203125, 6.0692911148071),
				heading = 270.0
			},
			{
				coords = vector3(557.99884033203, -3028.4060058594, 6.0284466743469),
				heading = 270.0
			},
			{
				coords = vector3(538.86798095703, -3028.2810058594, 6.0479683876038),
				heading = 270.0
			},
			{
				coords = vector3(515.41491699219, -3028.181640625, 6.0238337516785),
				heading = 270.0
			}
		},
		Destinations = {
			vector3(-15.93, -1104.25, 25.67), -- PDM
			vector3(-810.84, -228.29, 36.21), -- Luxury Autos
			vector3(868.27, -915.56, 25.03), -- Maibatsu Motors Factory
		}
	},
	{
		TrailerModel      = 'trailerlogs',
		PickupLocations = {
			{
				coords = vector3(-843.92, 5416.16, 36.46),
				heading = 79.30
			},
			{
				coords = vector3(-825.87756347656, 5414.6459960938, 34.297958374023),
				heading = 79.30
			},
			{
				coords = vector3(-797.21472167969, 5408.16015625, 33.966819763184),
				heading = 0.30
			},
			{
				coords = vector3(-802.88922119141, 5406.048828125, 34.072048187256),
				heading = 0.30
			},
			{
				coords = vector3(-778.05035400391, 5427.5454101563, 36.311107635498),
				heading = 79.30
			}
		},
		Destinations = {
			vector3(985.74, -2523.91, 27.3), -- Cypress Warehouses
		}
	},
	{
		TrailerModel      = 'tanker',
		PickupLocations = {
			{
				coords = vector3(518.88, -2156.75, 4.99),
				heading = 172.43
			},
			{
				coords = vector3(524.28302001953, -2139.9138183594, 5.9863386154175),
				heading = 172.43
			},
			{
				coords = vector3(520.22448730469, -2139.3540039063, 5.9863386154175),
				heading = 172.43
			},
			{
				coords = vector3(514.17633056641, -2138.5107421875, 5.9582934379578),
				heading = 172.43
			},
			{
				coords = vector3(508.66430664063, -2138.0532226563, 5.9175238609314),
				heading = 172.43
			},
			{
				coords = vector3(503.97494506836, -2139.0046386719, 5.9175305366516),
				heading = 172.43
			},
			{
				coords = vector3(501.04125976563, -2141.8215332031, 5.9175305366516),
				heading = 172.43
			},
			{
				coords = vector3(492.93795776367, -2151.8854980469, 5.9175372123718),
				heading = 262.43
			},
			{
				coords = vector3(492.6946105957, -2158.9296875, 5.9175372123718),
				heading = 262.43
			}
		},
		Destinations = {
			vector3(264.38, -1244.98, 28.14), -- Xero 24 (Postal 4027)
			vector3(1780.95, 3330.17, 40.25), -- Gas (Postal 802)
			vector3(-97.66, 6422.26, 30.43), -- Xero (Postal 911)
			vector3(-1811.93, 810.2, 137.53), -- Xero (Postal 911)
		}
	},
	{
		TrailerModel      = 'trailers',
		PickupLocations = {
			{
				coords = vector3(-2522.6572265625, 2341.6188964844, 33.05989074707),
				heading = 210.30
			},
			{
				coords = vector3(-2526.716796875, 2341.8117675781, 33.05989074707),
				heading = 210.30
			},
			{
				coords = vector3(-2530.8544921875, 2341.84375, 33.05989074707),
				heading = 210.30
			},
			{
				coords = vector3(-2534.4235839844, 2341.5913085938, 33.05989074707),
				heading = 210.30
			}
		},
		Destinations = {
			vector3(2825.8896484375, 1672.3699951172, 24.68688583374), -- factory place on east coast
		}
	},
}
