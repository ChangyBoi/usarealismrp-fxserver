local taxi_duty_locations = {
	["Los Santos"] = {
			duty = {
				x = 894.74,
				y = -180.43,
				z = 73.8,
				heading = 260.0
			},
			spawn = {
				x = 899.63,
				y = -180.77,
				z = 73.79,
				heading = 236.0
			}
	}
}

local NPC_REQUESTS_ENABLED = true

local JOB = {
	taxi = nil,
	isOnJob = false,
	start = nil,
	destination = nil,
	customer_ped = nil,
	end_time = nil
}

--------------------
-- list of models --
--------------------
local PED_MODELS = {
	"mp_m_freemode_01","mp_f_freemode_01","csb_abigail", "ig_abigail", "u_m_y_abner", "a_m_m_afriamer_01", "csb_agent", "ig_agent", "csb_mp_agent14", "ig_mp_agent14", "s_f_y_airhostess_01", "s_m_y_airworker", "u_m_m_aldinapoli", "s_m_m_movalien_01", "a_m_m_acult_01", "a_m_o_acult_01", "a_m_o_acult_02", "a_m_y_acult_01", "a_m_y_acult_02", "cs_amandatownley", "ig_amandatownley", "s_m_y_ammucity_01", "s_m_m_ammucountry", "csb_anita", "csb_anton", "u_m_y_antonb", "g_m_m_armboss_01", "g_m_m_armgoon_01", "g_m_y_armgoon_02", "g_m_m_armlieut_01", "mp_s_m_armoured_01", "s_m_m_armoured_01", "s_m_m_armoured_02", "s_m_y_armymech_01", "cs_ashley", "ig_ashley", "s_m_y_autopsy_01", "s_m_m_autoshop_01", "s_m_m_autoshop_02", "g_m_y_azteca_01", "u_m_y_babyd", "g_m_y_ballaeast_01", "g_f_y_ballas_01", "csb_ballasog", "ig_ballasog", "g_m_y_ballaorig_01", "g_m_y_ballasout_01", "cs_bankman", "ig_bankman", "u_m_m_bankman", "s_f_m_fembarber", "s_m_y_barman_01", "cs_barry", "ig_barry", "s_f_y_bartender_01", "s_m_m_cntrybar_01", "s_f_y_baywatch_01", "s_m_y_baywatch_01", "a_f_m_beach_01", "a_m_m_beach_01", "a_m_m_beach_02", "a_m_y_musclbeac_01", "a_m_y_musclbeac_02", "a_m_o_beach_01", "a_f_m_trampbeac_01", "a_m_m_trampbeac_01", "a_f_y_beach_01", "a_m_y_beach_01", "a_m_y_beach_02", "a_m_y_beach_03", "ig_benny", "ig_bestmen", "cs_beverly", "ig_beverly", "a_f_m_bevhills_01", "a_f_m_bevhills_02", "a_m_m_bevhills_01", "a_m_m_bevhills_02", "a_f_y_bevhills_01", "a_f_y_bevhills_02", "a_f_y_bevhills_03", "a_f_y_bevhills_04", "a_m_y_bevhills_01", "a_m_y_bevhills_02", "cs_orleans", "ig_orleans", "u_m_m_bikehire_01", "u_f_y_bikerchic", "a_m_y_stbla_01", "a_m_y_stbla_02", "a_f_m_bodybuild_01", "s_m_m_bouncer_01", "cs_brad", "ig_brad", "cs_bradcadaver", "a_m_y_breakdance_01", "csb_bride", "ig_bride", "csb_burgerdrug", "u_m_y_burgerdrug_01", "s_m_y_busboy_01", "a_m_y_busicas_01", "a_f_m_business_02", "a_m_m_business_01", "a_f_y_business_01", "a_f_y_business_02", "a_f_y_business_03", "a_f_y_business_04", "a_m_y_business_01", "a_m_y_business_02", "a_m_y_business_03", "s_m_o_busker_01", "csb_car3guy1", "ig_car3guy1", "csb_car3guy2", "ig_car3guy2", "cs_carbuyer", "cs_casey", "ig_casey", "s_m_y_chef_01", "csb_chef", "csb_chef2", "ig_chef", "ig_chef2", "s_m_m_chemsec_01-REMOVE", "g_m_m_chemwork_01", "g_m_m_chiboss_01", "g_m_m_chigoon_01", "csb_chin_goon", "g_m_m_chigoon_02", "g_m_m_chicold_01", "u_m_y_chip", "mp_m_claude_01", "ig_claypain", "cs_clay", "ig_clay", "csb_cletus", "ig_cletus", "s_m_y_clown_01", "s_m_y_construct_01", "s_m_y_construct_02", "u_f_m_corpse_01", "u_f_y_corpse_01", "u_f_y_corpse_02", "s_m_m_ccrew_01", "cs_chrisformage", "ig_chrisformage", "csb_customer", "a_m_y_cyclist_01", "u_m_y_cyclist_01", "cs_dale", "ig_dale", "cs_davenorton", "ig_davenorton", "mp_f_deadhooker", "s_m_y_dealer_01", "cs_debra", "cs_denise", "ig_denise", "csb_denise_friend", "cs_devin", "ig_devin", "s_m_y_devinsec_01", "csb_popov", "ig_popov", "u_m_m_doa_01", "s_m_m_dockwork_01", "s_m_y_dockwork_01", "s_m_m_doctor_01", "cs_dom", "ig_dom", "s_m_y_doorman_01", "a_m_y_dhill_01", "a_f_m_downtown_01", "a_m_y_downtown_01", "cs_drfriedlander", "ig_drfriedlander", "a_f_y_scdressy_01", "s_m_y_dwservice_01", "s_m_y_dwservice_02", "a_f_m_eastsa_01", "a_f_m_eastsa_02", "a_m_m_eastsa_01", "a_m_m_eastsa_02", "a_f_y_eastsa_01", "a_f_y_eastsa_02", "a_f_y_eastsa_03", "a_m_y_eastsa_01", "a_m_y_eastsa_02", "u_m_m_edtoh", "a_f_y_epsilon_01", "a_m_y_epsilon_01", "a_m_y_epsilon_02", "cs_tomepsilon", "ig_tomepsilon", "mp_m_exarmy_01", "u_m_y_militarybum", "cs_fabien", "ig_fabien", "s_f_y_factory_01", "s_m_y_factory_01", "g_m_y_famca_01", "mp_m_famdd_01", "g_m_y_famdnf_01", "g_f_y_families_01", "g_m_y_famfor_01", "csb_ramp_gang", "ig_ramp_gang", "a_m_m_farmer_01", "a_f_m_fatbla_01", "a_f_m_fatcult_01", "a_m_m_fatlatin_01", "a_f_m_fatwhite_01", "a_f_y_femaleagent", "cs_mrk", "ig_mrk", "u_m_o_finguru_01", "a_f_y_fitness_01", "a_f_y_fitness_02", "cs_floyd", "ig_floyd", "csb_fos_rep", "s_m_m_gaffer_01", "s_m_y_garbage", "s_m_m_gardener_01", "a_m_y_gay_01", "a_m_y_gay_02", "a_m_m_genfat_01", "a_m_m_genfat_02", "a_f_y_genhot_01", "a_f_o_genstreet_01", "a_m_o_genstreet_01", "a_m_y_genstreet_01", "a_m_y_genstreet_02", "csb_g", "u_m_m_glenstank_01", "a_m_m_golfer_01", "a_f_y_golfer_01", "a_m_y_golfer_01", "u_m_m_griff_01", "s_m_y_grip_01", "csb_groom", "ig_groom", "csb_grove_str_dlr", "cs_guadalope", "u_m_y_guido_01", "u_m_y_gunvend_01", "cs_gurk", "s_m_m_hairdress_01", "csb_hao", "ig_hao", "a_m_m_hasjew_01", "a_m_y_hasjew_01", "csb_ramp_hic", "ig_ramp_hic", "s_m_m_highsec_01", "s_m_m_highsec_02", "a_f_y_hiker_01", "a_m_y_hiker_01", "a_m_m_hillbilly_01", "a_m_m_hillbilly_02", "a_f_y_hippie_01", "u_m_y_hippie_01", "a_m_y_hippy_01", "csb_ramp_hipster", "ig_ramp_hipster", "a_f_y_hipster_01", "a_f_y_hipster_02", "a_f_y_hipster_03", "a_f_y_hipster_04", "a_m_y_hipster_01", "a_m_y_hipster_02", "a_m_y_hipster_03", "s_f_y_hooker_01", "s_f_y_hooker_02", "s_f_y_hooker_03", "u_f_y_hotposh_01", "csb_hugh", "cs_hunter", "ig_hunter", "u_m_y_imporage", "csb_imran", "a_m_m_indian_01", "a_f_o_indian_01", "a_f_y_indian_01", "a_m_y_indian_01", "u_f_y_comjane", "cs_janet", "ig_janet", "csb_janitor", "s_m_m_janitor", "ig_jay_norris", "u_m_o_taphillbilly", "u_m_m_jesus_01", "a_m_y_jetski_01", "hc_driver", "hc_gunman", "hc_hacker", "u_m_m_jewelthief", "u_f_y_jewelass_01", "cs_jewelass", "ig_jewelass", "u_m_m_jewelsec_01", "cs_jimmyboston", "ig_jimmyboston", "cs_jimmydisanto", "ig_jimmydisanto", "a_f_y_runner_01", "a_m_y_runner_01", "a_m_y_runner_02", "mp_m_marston_01", "cs_johnnyklebitz", "ig_johnnyklebitz", "cs_josef", "ig_josef", "cs_josh", "ig_josh", "a_f_y_juggalo_01", "a_m_y_juggalo_01", "u_m_y_justin", "ig_kerrymcintosh", "u_m_y_baygor", "g_m_m_korboss_01", "a_f_m_ktown_01", "a_f_m_ktown_02", "g_m_y_korlieut_01", "a_m_m_ktown_01", "a_f_o_ktown_01", "a_m_o_ktown_01", "g_m_y_korean_01", "a_m_y_ktown_01", "g_m_y_korean_02", "a_m_y_ktown_02", "cs_lamardavis", "ig_lamardavis", "s_m_m_lathandy_01", "a_m_m_stlat_02", "a_m_y_stlat_01", "a_m_y_latino_01", "cs_lazlow", "ig_lazlow", "cs_lestercrest", "ig_lestercrest", "cs_lifeinvad_01", "ig_lifeinvad_01", "ig_lifeinvad_02", "s_m_m_lifeinvad_01", "s_m_m_linecook", "u_m_m_willyfist", "s_m_m_lsmetro_01", "cs_magenta", "ig_magenta", "s_f_m_maid_01", "a_m_m_malibu_01", "u_m_y_mani", "cs_manuel", "ig_manuel", "s_m_m_mariachi_01", "u_m_m_markfost", "cs_marnie", "ig_marnie", "cs_martinmadrazo", "cs_maryann", "ig_maryann", "csb_maude", "ig_maude", "csb_rashcosvki", "ig_rashcosvki", "s_m_y_xmech_01", "s_m_y_xmech_02", "csb_mweather", "a_m_y_methhead_01", "csb_ramp_mex", "ig_ramp_mex", "g_m_m_mexboss_01", "g_m_m_mexboss_02", "g_m_y_mexgang_01", "g_m_y_mexgoon_01", "g_m_y_mexgoon_02", "g_m_y_mexgoon_03", "a_m_m_mexlabor_01", "a_m_m_mexcntry_01", "a_m_y_mexthug_01", "cs_michelle", "ig_michelle", "s_f_y_migrant_01", "s_m_m_migrant_01", "cs_milton", "ig_milton", "s_m_y_mime", "cs_joeminuteman", "ig_joeminuteman", "u_f_m_miranda", "u_f_y_mistress", "mp_f_misty_01", "cs_molly", "ig_molly", "csb_money", "ig_money", "a_m_y_motox_01", "a_m_y_motox_02", "s_m_m_movspace_01", "u_m_m_filmdirector", "s_f_y_movprem_01", "cs_movpremf_01", "s_m_m_movprem_01", "cs_movpremmale", "u_f_o_moviestar", "cs_mrsphillips", "ig_mrsphillips", "cs_mrs_thornhill", "ig_mrs_thornhill", "cs_natalia", "ig_natalia", "cs_nervousron", "ig_nervousron", "cs_nigel", "ig_nigel", "mp_m_niko_01", "a_m_m_og_boss_01", "cs_old_man1a", "ig_old_man1a", "cs_old_man2", "ig_old_man2", "cs_omega", "ig_omega", "ig_oneil", "csb_ortega", "ig_ortega", "csb_oscar", "csb_paige", "ig_paige", "a_m_m_paparazzi_01", "u_m_y_paparazzi", "u_m_m_partytarget", "u_m_y_party_01", "cs_patricia", "ig_patricia", "s_m_y_pestcont_01", "cs_dreyfuss", "ig_dreyfuss", "s_m_m_pilot_01", "s_m_y_pilot_01", "u_m_y_pogo_01", "a_m_m_polynesian_01", "g_m_y_pologoon_01", "g_m_y_pologoon_02", "a_m_y_polynesian_01", "u_f_y_poppymich", "csb_porndudes", "s_m_m_postal_01", "s_m_m_postal_02", "cs_priest", "ig_priest", "u_f_y_princess", "u_m_y_proldriver_01", "csb_prologuedriver", "a_f_m_prolhost_01", "a_m_m_prolhost_01", "u_f_o_prolhost_01", "u_f_m_promourn_01", "u_m_m_promourn_01", "csb_prolsec", "u_m_m_prolsec_01", "cs_prolsec_02", "ig_prolsec_02", "mp_g_m_pros_01", "csb_reporter", "u_m_y_rsranger_01", "u_m_m_rivalpap", "a_m_y_roadcyc_01", "s_m_y_robber_01", "csb_roccopelosi", "ig_roccopelosi", "a_f_y_rurmeth_01", "a_m_m_rurmeth_01", "cs_russiandrunk", "ig_russiandrunk", "s_f_m_shop_high", "s_f_y_shop_low", "s_m_y_shop_mask", "s_f_y_shop_mid", "a_f_m_salton_01", "a_m_m_salton_01", "a_m_m_salton_02", "a_m_m_salton_03", "a_m_m_salton_04", "a_f_o_salton_01", "a_m_o_salton_01", "a_m_y_salton_01", "g_m_y_salvaboss_01", "g_m_y_salvagoon_01", "g_m_y_salvagoon_02", "g_m_y_salvagoon_03", "s_m_m_scientist_01", "csb_screen_writer", "ig_screen_writer", "s_m_m_security_01", "mp_m_shopkeep_01", "cs_siemonyetarian", "ig_siemonyetarian", "a_f_y_skater_01", "a_m_m_skater_01", "a_m_y_skater_01", "a_m_y_skater_02", "a_f_m_skidrow_01", "a_m_m_skidrow_01", "cs_solomon", "ig_solomon", "a_f_m_soucent_01", "a_f_m_soucent_02", "a_m_m_socenlat_01", "a_m_m_soucent_01", "a_m_m_soucent_02", "a_m_m_soucent_03", "a_m_m_soucent_04", "a_f_m_soucentmc_01", "a_f_o_soucent_01", "a_f_o_soucent_02", "a_m_o_soucent_01", "a_m_o_soucent_02", "a_m_o_soucent_03", "a_f_y_soucent_01", "a_f_y_soucent_02", "a_f_y_soucent_03", "a_m_y_soucent_01", "a_m_y_soucent_02", "a_m_y_soucent_03", "a_m_y_soucent_04", "u_m_y_sbike", "u_m_m_spyactor", "u_f_y_spyactress", "u_m_y_staggrm_01", "s_m_m_strperf_01", "s_m_m_strpreach_01", "g_m_y_strpunk_01", "g_m_y_strpunk_02", "s_m_m_strvend_01", "s_m_y_strvend_01", "cs_stretch", "ig_stretch", "csb_stripper_01", "s_f_y_stripper_01", "csb_stripper_02", "s_f_y_stripper_02", "s_f_y_stripperlite", "mp_f_stripperlite", "a_m_y_sunbathe_01", "a_m_y_surfer_01", "s_f_m_sweatshop_01", "s_f_y_sweatshop_01", "ig_talina", "cs_tanisha", "ig_tanisha", "cs_taocheng", "ig_taocheng", "cs_taostranslator", "ig_taostranslator", "u_m_y_tattoo_01", "cs_tenniscoach", "ig_tenniscoach", "a_f_y_tennis_01", "a_m_m_tennis_01", "cs_terry", "ig_terry", "g_f_y_lost_01", "g_m_y_lost_01", "g_m_y_lost_02", "g_m_y_lost_03", "cs_tom", "csb_tonya", "ig_tonya", "a_f_y_topless_01", "a_f_m_tourist_01", "a_m_m_tourist_01", "a_f_y_tourist_01", "a_f_y_tourist_02", "cs_tracydisanto", "ig_tracydisanto", "a_f_m_tramp_01", "a_m_m_tramp_01", "u_m_o_tramp_01", "a_m_o_tramp_01", "s_m_m_gentransport", "a_m_m_tranvest_01", "a_m_m_tranvest_02", "s_m_m_trucker_01", "ig_tylerdix", "csb_undercover", "cs_paper", "ig_paper", "s_m_m_ups_01", "s_m_m_ups_02", "s_m_y_uscg_01", "g_f_y_vagos_01", "csb_vagspeak", "ig_vagspeak", "mp_m_g_vagfun_01", "s_m_y_valet_01", "a_m_y_beachvesp_01", "a_m_y_beachvesp_02", "a_m_y_vindouche_01", "a_f_y_vinewood_01", "a_f_y_vinewood_02", "a_f_y_vinewood_03", "a_f_y_vinewood_04", "a_m_y_vinewood_01", "a_m_y_vinewood_02", "a_m_y_vinewood_03", "a_m_y_vinewood_04", "cs_wade", "ig_wade", "s_m_y_waiter_01", "cs_chengsr", "ig_chengsr", "a_m_y_stwhi_01", "a_m_y_stwhi_02", "s_m_y_winclean_01", "a_f_y_yoga_01", "a_m_y_yoga_01", "cs_zimbor", "ig_zimbor", "u_m_y_zombie_01"}


local LOCATIONS = {
	{x = -423.45, y = 5971.05, z = 31.49, name = "Sheriff's Office - Paleto", arrived = false},
	{x = 184.412, y = 6633.04,  z = 31.56, name = "Paleto Blvd / Pyrite Ave.", arrived = false},
	{x = -256.11, y = 6265.68, z = 31.42, name = "Hen House - Paleto", arrived = false},
	--{x = -221.63, y = 6325.18, z = 31.46, name = "UNKNOWN", arrived = false},
	--{x = -170.38, y = 6379.18, z = 31.47, name = "UNKNOWN", arrived = false},
	{x = 56.25, y = 6607.67, z = 31.42, name = "Paleto Blvd.", arrived = false},
	--{x = 914.06, y = 6478.74, z = 21.27, name = "UNKNOWN", arrived = false},
	--{x = 1725.16, y = 6409.43, z = 34.26, name = "UNKNOWN", arrived = false},
	{x = 2751.39, y = 4405.67, z = 48.69, name = "East Joshua Rd.", arrived = false},
	{x = 934.95, y = 3546.02, z = 33.99, name = "Marina Dr. / E. Joshua", arrived = false},
	{x = -1292.26, y = 2545.11, z = 18.01, name = "Fort Zancudo - Route 68", arrived = false},
	{x = -859.79, y = 5422.63, z = 34.91, name = "Lumber Yard - GOH", arrived = false},
	{x = -391.85, y = 6051.66, z = 31.5, name = "Paleto Blvd. / GOH", arrived = false},
	{x = -426.28, y = 6029.36, z = 31.5, name = "Paleto Blvd. / GOH", arrived = false},
	{x = -686.5, y = 5838.5, z = 17.3, name = "Bayview Lodge", arrived = false},
	{x = -710.08, y = 5787.66, z = 17.4, name = "Bayview Lodge", arrived = false},
	{x = -767.45, y = 5556.3, z = 33.6, name = "Bike Shop", arrived = false},
	{x = -776.6, y = 5592.9, z = 33.6, name = "Bike Shop", arrived = false},
	{x = -1583.6, y = 5170.87, z = 19.56, name = "Fishing Dock", arrived = false},
	{x = -2203.84, y = 4274.9, z = 48.3, name = "Hookies Restaruant", arrived = false},
	{x = -2205.6, y = 4283.4, z = 48.5, name = "Hookies Restaruant", arrived = false},
	{x = -2508.6, y = 3620.6, z = 13.7, name = "Great Ocean Highway", arrived = false},
	{x = -2561.1, y = 2316.8, z = 33.2, name = "Ron Gas Station", arrived = false},
	{x = -2536.4, y = 2318.6, z = 33.2, name = "Ron Gas Station", arrived = false},
	{x = 1720.6, y = 6416.8, z = 33.7, name = "24/7 Paleto", arrived = false},
	{x = 1684.0, y = 6421.3, z = 32.3, name = "24/7 Paleto", arrived = false},
	{x = 1593.5, y = 6447.5, z = 25.3, name = "Up N' Atom", arrived = false},
	{x = 1515.0, y = 6332.8, z = 24.1, name = "Great Ocean Highway", arrived = false},
	{x = 2174.3, y = 4760.6, z = 41.1, name = "Grapeseed Airfield", arrived = false},
	{x = 1778.1, y = 4587.0, z = 37.7, name = "Seaview Rd.", arrived = false},
	{x = 1705.13, y = 4692.9, z = 42.7, name = "Grapeseed Main St.", arrived = false},
	{x = 1680.8, y = 4827.9, z = 42.0, name = "Grapeseed Clothing", arrived = false},
	{x = 1658.6, y = 4869.8, z = 42.1, name = "Grapeseed Main St.", arrived = false},
	{x = 1704.4, y = 4940.8, z = 42.1, name = "Grapeseed Garage", arrived = false},
	{x = 1687.6, y = 4912.1, z = 42.1, name = "Grapeseed Garage", arrived = false},
	{x = 1923.5, y = 5152.5, z = 44.6, name = "Grapeseed Main St.", arrived = false},
	{x = 1983.0, y = 3064.6, z = 47.2, name = "Yellow Jack", arrived = false},
	{x = 2010.2, y = 3051.9, z = 47.2, name = "Yellow Jack", arrived = false},
	{x = 1770.1, y = 3338.7, z = 41.4, name = "Sandy Shores Airport", arrived = false},
	{x = 1817.8, y = 3659.8, z = 34.3, name = "Alhambra Dr.", arrived = false},
	{x = 1853.0, y = 3706.5, z = 33.2, name = "Zancudo Ave.", arrived = false},
	{x = 1863.9, y = 3741.9, z = 33.1, name = "Zancudo Ave.", arrived = false},
	{x = 1696.9, y = 3771.3, z = 34.7, name = "Algonquin Blvd.", arrived = false},
	{x = 1513.0, y = 3766.3, z = 34.2, name = "Sandy Shores Garage", arrived = false},
	{x = 1992.7, y = 3759.2, z = 32.2, name = "Alhambra Dr.", arrived = false},
	{x = 1853.4, y = 2582.1, z = 45.7, name = "Bolingbroke Prison", arrived = false},
	{x = 1853.3, y = 2592.5, z = 45.7, name = "Bolingbroke Prison", arrived = false},
	{x = 1852.5, y = 2615.1, z = 45.7, name = "Bolingbroke Prison", arrived = false},
	{x = 77.2, y = -972.4, z = 29.4, name = "Vespucci Blvd. / Elgin Ave.", arrived = false},
	{x = 197.5, y = -1066.3, z = 29.3, name = "Strawberry Ave. / Vespucci Blvd.", arrived = false},
	{x = 90.6, y = -1076.7, z = 29.3, name = "Elgin Ave.", arrived = false},
	{x = 5.6, y = -1124.3, z = 28.4, name = "Adam's Apple Blvd.", arrived = false},
	{x = -191.9, y = -1295.3, z = 31.3, name = "Benny's / Power St.", arrived = false},
	{x = -171.5, y = -1415.2, z = 31.1, name = "Innocence Blvd.", arrived = false},
	{x = 5.3, y = -1594.8, z = 29.3, name = "Strawberry Ave.", arrived = false},
	{x = 104.3, y = -1429.4, z = 29.3, name = "Strawberry Ave.", arrived = false},
	{x = 112.0, y = -1344.6, z = 29.3, name = "Vanilla Unicorn", arrived = false},
	{x = 162.4, y = -891.2, z = 30.5, name = "Legion Square", arrived = false},
	{x = 224.8, y = -857.7, z = 30.11, name = "Legion Square", arrived = false},
	{x = 216.2, y = -817.9, z = 30.6, name = "Legion Square", arrived = false},
	{x = 282.1, y = -610.7, z = 43.3, name = "Pillbox Hill Hospital", arrived = false},
	{x = 315.7, y = 167.9, z = 103.8, name = "Vinewood Blvd.", arrived = false},
	{x = 280.1, y = 180.9, z = 104.5, name = "Vinewood Blvd.", arrived = false},
	{x = -429.0, y = 255.7, z = 83.1, name = "Eclipse Blvd.", arrived = false},
	{x = -558.2, y = 269.7, z = 83.02, name = "Tequilala", arrived = false},
	{x = -576.5, y = 271.4, z = 82.8, name = "Tequilala", arrived = false},
	{x = -610.5, y = -167.5, z = 37.8, name = "Eastbourne Way", arrived = false},
	{x = -1013.4, y = -690.7, z = 21.3, name = "San Andreas Ave.", arrived = false},
	{x = -1069.9, y = -795.9, z = 19.3, name = "South Rockford Dr.", arrived = false},
	{x = -190.9, y = -1610.9, z = 33.9, name = "Forum Dr.", arrived = false},
	{x = -102.7, y = -1775.7, z = 29.5, name = "Grove St.", arrived = false}
}

RegisterNetEvent("taxi:toggleNPCRequests")
AddEventHandler("taxi:toggleNPCRequests", function()
	if NPC_REQUESTS_ENABLED and JOB.isOnJob then
		JOB.isOnJob = false
		JOB.end_time = GetGameTimer()
		TriggerEvent("swayam:RemoveWayPoint")
	end
	NPC_REQUESTS_ENABLED = not NPC_REQUESTS_ENABLED
	if NPC_REQUESTS_ENABLED then
		exports.globals:notify('You are now ~g~accepting~s~ taxi requests from locals!')
	else
		exports.globals:notify('Taxi requests from locals have been temporarily ~y~muted~s~!')
	end
end)


RegisterNetEvent("taxiJob:onDuty")
AddEventHandler("taxiJob:onDuty", function()
	DrawCoolLookingNotificationWithTaxiPic("Here's your cab! Have a good shift!")
	SpawnTaxi()
end)

RegisterNetEvent("taxiJob:offDuty")
AddEventHandler("taxiJob:offDuty", function()
	DrawCoolLookingNotificationWithTaxiPic("You have clocked out! Have a good one!")
	if JOB.isOnJob then
		TaskLeaveVehicle(JOB.customer_ped, JOB.taxi, 1)
		JOB.isOnJob = false
		JOB.end_time = GetGameTimer()
		TriggerEvent("swayam:RemoveWayPoint")
	end
	--print('taxi:' .. JOB.taxi)
	DelVehicle(JOB.taxi)
	JOB.taxi = nil
end)

--------------------------------------
-- GENERATE RANDOM NPC JOB PICK UPS --
--------------------------------------
Citizen.CreateThread(function()

	local AUTO_JOB_TIME_DELAY = 120000 -- in milliseconds

	function GenerateNPCJob()
		local model = GetHashKey(PED_MODELS[math.random(#PED_MODELS)])
		local start_location = LOCATIONS[math.random(#LOCATIONS)]
		local end_location = LOCATIONS[math.random(#LOCATIONS)]
		while end_location == start_location do
			end_location = LOCATIONS[math.random(#LOCATIONS)]
		end
		TriggerEvent("chatMessage", "", {}, "^3^*[DISPATCH] ^r^7A pickup has been requested at ^3" .. start_location.name .. "^7, please respond as soon as possible!")
		TriggerServerEvent('InteractSound_SV:PlayOnSource', 'demo', 0.1)
		--ClearGpsPlayerWaypoint()
		--SetNewWaypoint(start_location.x, start_location.y)
		TriggerEvent("swayam:SetWayPointWithAutoDisable", start_location.x, start_location.y, start_location.z, 280, 60, "Taxi Request")
		RequestModel(model)
		while not HasModelLoaded(model) do
			Citizen.Wait(100)
		end
		JOB.customer_ped = CreatePed(4, model, start_location.x, start_location.y, start_location.z, 0.0 --[[Heading]], true --[[Networked, set to false if you just want to be visible by the one that spawned it]], false --[[Dynamic]])
		-- TODO: make ped start random scenario
		SetEntityAsMissionEntity(JOB.customer_ped, true, true)
		JOB.isOnJob = true
		JOB.start = start_location
		JOB.destination = end_location
		JOB.destination.arrived = false
		JOB.start.arrived = false
	end

	while true do
		Citizen.Wait(1)
		local playerPed = PlayerPedId()
		------------------------------------------------
		-- unlock the door just in case it was locked --
		------------------------------------------------
		if JOB.customer_ped then
			local npcs_target_vehicle = GetVehiclePedIsTryingToEnter(JOB.customer_ped)
			if GetVehicleDoorLockStatus(npcs_target_vehicle) ~= 1 then
				SetVehicleDoorsLocked(npcs_target_vehicle, 1)
			end
		end
		----------------
		-- NOT ON JOB --
		----------------
		if NPC_REQUESTS_ENABLED then
			if not JOB.isOnJob and GetVehiclePedIsIn(playerPed, false) == JOB.taxi then
				if JOB.end_time then -- had previous job
					if GetGameTimer() - JOB.end_time >= AUTO_JOB_TIME_DELAY then
						GenerateNPCJob()
					end
				else -- this will be first job
					Wait(math.random(30000, 90000))
					GenerateNPCJob()
				end
			end
		end
		----------------------
		-- ON JOB -- PICKUP --
		----------------------
		if JOB.isOnJob and GetVehiclePedIsIn(playerPed, false) == JOB.taxi then
			local playerCoords = GetEntityCoords(playerPed)
			if Vdist(playerCoords, JOB.start.x, JOB.start.y, JOB.start.z) < 8.5 and not JOB.start.arrived then
				TaskEnterVehicle(JOB.customer_ped, JOB.taxi, 10000, 1, 1.0, 1, 0)
				JOB.start.arrived = true
				--ClearGpsPlayerWaypoint()
				--SetNewWaypoint(JOB.destination.x, JOB.destination.y)
				TriggerEvent("swayam:SetWayPointWithAutoDisable", JOB.destination.x, JOB.destination.y, JOB.destination.z, 1, 60, "Taxi Destination")
				TriggerEvent("usa:notify", "Take the customer safely to ~y~" .. JOB.destination.name .. '~s~.')
			end
		end
		---------------------
		-- ON JOB -- ROUTE --
		---------------------
		if JOB.isOnJob and GetVehiclePedIsIn(playerPed, false) == JOB.taxi then
			local playerCoords = GetEntityCoords(playerPed)
			if Vdist(playerCoords, JOB.destination.x, JOB.destination.y, JOB.destination.z) < 8 and not JOB.destination.arrived then
				TaskLeaveVehicle(JOB.customer_ped, JOB.taxi, 1)
				TaskWanderStandard(JOB.customer_ped, 10.0, 10)
				JOB.destination.arrived = true
				JOB.isOnJob = false
				JOB.end_time = GetGameTimer()
				JOB.customer_ped = nil
				TriggerServerEvent("taxiJob:payDriver", Vdist(JOB.start.x, JOB.start.y, JOB.start.z, JOB.destination.x, JOB.destination.y, JOB.destination.z))
			end
		end
		---------------------------------
		-- CHECK FOR JOB ENDING EVENTS --
		---------------------------------
		if JOB.isOnJob and (IsPedDeadOrDying(JOB.customer_ped, 1) or not DoesEntityExist(JOB.customer_ped) or (JOB.start.arrived == true and Vdist(GetEntityCoords(JOB.customer_ped), GetEntityCoords(JOB.taxi)) > 10.0)) then
			JOB.isOnJob = false
			JOB.end_time = GetGameTimer()
			TriggerEvent("swayam:RemoveWayPoint")
			TriggerEvent("usa:notify", "Your current taxi request has been ended.")
		end
		------------------
		-- DRAW MARKERS --
		------------------
		if JOB.isOnJob then
			if not JOB.start.arrived then
				DrawText3D(JOB.start.x, JOB.start.y, JOB.start.z, 30, 'Customer')
			elseif not JOB.destination.arrived and JOB.start.arrived then
				DrawText3D(JOB.destination.x, JOB.destination.y, JOB.destination.z, 30, 'Destination')
			end
		end
	end

end)

local closest_location = {}

Citizen.CreateThread(function()
	EnumerateBlips()
	local timeout = 0
	while true do
		for name, data in pairs(taxi_duty_locations) do
			DrawText3D(data.duty.x, data.duty.y, (data.duty.z + 1.0), 20, '[E] - On/Off Duty (~y~Taxi~s~)')
		end
		if IsControlJustPressed(0, 38) then
			for name, data in pairs(taxi_duty_locations) do
		        local playerCoords = GetEntityCoords(PlayerPedId(), false)
			    if GetDistanceBetweenCoords(playerCoords, data.duty.x, data.duty.y, data.duty.z, true) < 3 then
			    	if timeout > 3 then
						TriggerEvent('usa:notify', "You have clocked in and out too much recently, ~y~please wait~s~.")
					else
						timeout = timeout + 1
						if timeout > 3 then
							Citizen.CreateThread(function()
								local beginTime = GetGameTimer()
								while GetGameTimer() - beginTime < 10000 do
									Citizen.Wait(100)
								end
								timeout = 0
							end)
						end
						TriggerServerEvent("taxiJob:setJob")
						JOB.isOnJob = false
						JOB.end_time = GetGameTimer()
						TriggerEvent("swayam:RemoveWayPoint")
						closest_location = data
					end
				end
			end
		end
		Wait(1)
	end
end)

function SpawnTaxi()
	local numberHash = -956048545
	Citizen.CreateThread(function()
		RequestModel(numberHash)
		while not HasModelLoaded(numberHash) do
			Wait(100)
		end
		JOB.taxi = CreateVehicle(numberHash, closest_location.spawn.x, closest_location.spawn.y, closest_location.spawn.z, closest_location.spawn.heading, true, false)
		SetVehicleOnGroundProperly(JOB.taxi)
		SetVehRadioStation(JOB.taxi, "OFF")
		SetEntityAsMissionEntity(JOB.taxi, true, true)
		SetVehicleExplodesOnHighExplosionDamage(JOB.taxi, true)

		local vehicle_key = {
			name = "Key -- " .. GetVehicleNumberPlateText(JOB.taxi),
			quantity = 1,
			type = "key",
			owner = "Downtown Taxi Co.",
			make = "Vapid",
			model = "Stanier",
			plate = GetVehicleNumberPlateText(JOB.taxi)
		}

		-- give key to owner
		TriggerServerEvent("garage:giveKey", vehicle_key)
		TriggerServerEvent('mdt:addTempVehicle', 'Vapid Stainer (Taxi)', "Downtown Cab Co.", GetVehicleNumberPlateText(JOB.taxi))
	end)
end

RegisterNetEvent('character:setCharacter')
AddEventHandler('character:setCharacter', function()
	JOB.isOnJob = false
	JOB.end_time = GetGameTimer()
	TriggerEvent("swayam:RemoveWayPoint")
end)

function DrawCoolLookingNotificationWithTaxiPic(name, msg)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(msg)
	SetNotificationMessage("CHAR_TAXI", "CHAR_TAXI", true, 1, name, "", msg)
	DrawNotification(0,1)
end

function DrawText3D(x, y, z, distance, text)
  if Vdist(GetEntityCoords(PlayerPedId()), x, y, z) < distance then
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 470
    DrawRect(_x,_y+0.0125, 0.015+factor, 0.03, 41, 11, 41, 68)
  end
end

-- Delete car function borrowed frtom Mr.Scammer's model blacklist, thanks to him!
function DelVehicle(entity)
    Citizen.InvokeNative( 0xEA386986E786A54F, Citizen.PointerValueIntInitialized( entity ) )
end

function EnumerateBlips()
	for name, data in pairs(taxi_duty_locations) do
      	local blip = AddBlipForCoord(data.duty.x, data.duty.y, data.duty.z)
		SetBlipSprite(blip, 198)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.75)
		SetBlipAsShortRange(blip, true)
		SetBlipColour(blip, 33)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Downtown Cab Co.')
		EndTextCommandSetBlipName(blip)
    end
end
