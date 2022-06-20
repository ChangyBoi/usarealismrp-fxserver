local LEO_VEHICLES = {"pcvpi","p14charger", "p16explorer", "p18charger", "p18f250", "p18taurus", "p20explorer", "p20tahoe", "p21durango", "p21tahoe", "p22sierra", "sotruck", "1200RT", "policebikerb", "npolchar", "npolstang", "npolchal", "npolvette", "fbi2", "bearcatrb", "14suvrb", "pbus", "policet"}

local JOB_VEHICLES = {
	["sheriff"] = LEO_VEHICLES,
	["corrections"] = LEO_VEHICLES,
	["ems"] = {"ambulance", "p20explorer", "p21tahoe", "firetruk", "lguard2", "blazer", "sotruck"},
	["doctor"] = {"p20explorer", "p21tahoe"}
}

RegisterServerEvent("pdmenu:checkWhitelistForGarage")
AddEventHandler("pdmenu:checkWhitelistForGarage", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local user_job = char.get("job")
	if user_job == "sheriff" or user_job == "corrections" or user_job == "ems" or user_job == "doctor" then
		TriggerClientEvent('pdmenu:openGarageMenu', source, JOB_VEHICLES[user_job], user_job)
	else
		TriggerClientEvent("usa:notify", source, "~y~You are not on duty!.")
	end
end)

RegisterServerEvent("pdmenu:checkWhitelistForCustomization")
AddEventHandler("pdmenu:checkWhitelistForCustomization", function()
	local char = exports["usa-characters"]:GetCharacter(source)
	local user_job = char.get("job")
	if user_job == "sheriff" or user_job == "corrections" or user_job == "ems" or user_job == "doctor" then
		TriggerClientEvent('pdmenu:openCustomizationMenu', source)
	else
		TriggerClientEvent("usa:notify", source, "~y~You are not on duty!.")
	end
end)
