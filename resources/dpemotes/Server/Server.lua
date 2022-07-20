
-----------------------------------------------------------------------------------------------------
-- Shared Emotes Syncing  ---------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

RegisterServerEvent("ServerEmoteRequest")
AddEventHandler("ServerEmoteRequest", function(target, emotename, etype)
	TriggerClientEvent("ClientEmoteRequestReceive", target, emotename, etype)
end)

RegisterServerEvent("ServerValidEmote") 
AddEventHandler("ServerValidEmote", function(target, requestedemote, otheremote)
	TriggerClientEvent("SyncPlayEmote", source, otheremote, source)
	TriggerClientEvent("SyncPlayEmoteSource", target, requestedemote)
end)

RegisterServerCallback {
	eventName = 'emote:isAtBlacklistedLocation',
	eventCallback = function(source, emoteName)
		return isAtBlacklistedLocation(source, emoteName[3])
	end
}

function isAtBlacklistedLocation(src, emoteName)
	local mycoords = GetEntityCoords(GetPlayerPed(src))
	if Config.BlacklistedLocations[emoteName] then
		for i = 1, #Config.BlacklistedLocations[emoteName] do
			local location = Config.BlacklistedLocations[emoteName][i]
			if #(mycoords - location.coords) <= location.dist then
				return true
			end
		end
	end
	return false
end

TriggerEvent('es:addCommand', 'e', function(source, args, char)
	if args[2] and args[2]:lower() == "sunbatheback" and char.get("jailTime") > 0 then
		return
	end
	if isAtBlacklistedLocation(source, args[2]) then
		TriggerClientEvent("usa:notify", source, "Can't do that here!")
		return
	end
	table.remove(args, 1)
	TriggerClientEvent("dpemotes:command", source, 'e', source, args)
end, { help = "List emotes" })

TriggerEvent('es:addCommand', 'emote', function(source, args, char)
	if args[2] and args[2]:lower() == "sunbatheback" and char.get("jailTime") > 0 then
		return
	end
	if isAtBlacklistedLocation(source, args[2]) then
		TriggerClientEvent("usa:notify", source, "Can't do that here!")
		return
	end
	table.remove(args, 1)
	TriggerClientEvent("dpemotes:command", source, 'e', source, args)
end, { help = "List emotes" })

TriggerEvent('es:addCommand', 'emotes', function(source, args, char)
	table.remove(args, 1)
	TriggerClientEvent("dpemotes:command", source, 'emotes', source, args)
end, { help = "List emotes" })

TriggerEvent('es:addCommand', 'emotemenu', function(source, args, char)
	table.remove(args, 1)
	TriggerClientEvent("dpemotes:command", source, 'emotemenu', source, args)
end, { help = "Open emote menu" })

TriggerEvent('es:addCommand', 'walk', function(source, args, char)
	table.remove(args, 1)
	TriggerClientEvent("dpemotes:command", source, 'walk', source, args)
end, { help = "Change walk" })

TriggerEvent('es:addCommand', 'walks', function(source, args, char)
	table.remove(args, 1)
	TriggerClientEvent("dpemotes:command", source, 'walks', source, args)
end, { help = "List walks" })

TriggerEvent('es:addCommand', 'nearby', function(source, args, char)
	table.remove(args, 1)
	TriggerClientEvent("dpemotes:nearbyCommand", source, args)
end, { help = "Perform emote with someone nearby!" })

TriggerEvent('es:addCommand', 'emotebind', function(src, args, char)
	table.remove(args, 1)
	TriggerClientEvent("dpemotes:command", src, 'emotebind', src, args)
end, {
	help = "Bind an emote",
	params = {
		{ name = "key", help = "num4, num5, num6, num7. num8, num9. Numpad 4-9!" },
		{ name = "emote", help = "any valid emote name" },
	}
})

TriggerEvent('es:addCommand', 'emotebinds', function(source, args, char)
	TriggerClientEvent("dpemotes:command", source, 'emotebinds', args)
end, { help = "See currently bound emotes" })

-----------------------------------------------------------------------------------------------------
-- Keybinding  --------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

if Config.SqlKeybinding then
  MySQL.ready(function()

	RegisterServerEvent("dp:ServerKeybindExist")
	AddEventHandler('dp:ServerKeybindExist', function()
		local src = source local srcid = GetPlayerIdentifier(source)
		MySQL.Async.fetchAll('SELECT * FROM dpkeybinds WHERE `id`=@id;', {id = srcid}, function(dpkeybinds)
			if dpkeybinds[1] then
				TriggerClientEvent("dp:ClientKeybindExist", src, true)
			else
				TriggerClientEvent("dp:ClientKeybindExist", src, false)
			end
		end)
	end)

	--  This is my first time doing SQL stuff, and after i finished everything i realized i didnt have to store the keybinds in the database at all.
	--  But remaking it now is a little pointless since it does it job just fine!

	RegisterServerEvent("dp:ServerKeybindCreate")
	AddEventHandler("dp:ServerKeybindCreate", function()
		local src = source local srcid = GetPlayerIdentifier(source)
		MySQL.Async.execute('INSERT INTO dpkeybinds (`id`, `keybind1`, `emote1`, `keybind2`, `emote2`, `keybind3`, `emote3`, `keybind4`, `emote4`, `keybind5`, `emote5`, `keybind6`, `emote6`) VALUES (@id, @keybind1, @emote1, @keybind2, @emote2, @keybind3, @emote3, @keybind4, @emote4, @keybind5, @emote5, @keybind6, @emote6);',
		{id = srcid, keybind1 = "num4", emote1 = "", keybind2 = "num5", emote2 = "", keybind3 = "num6", emote3 = "", keybind4 = "num7", emote4 = "", keybind5 = "num8", emote5 = "", keybind6 = "num9", emote6 = ""}, function(created) print("[dp] ^2"..GetPlayerName(src).."^7 got created!") TriggerClientEvent("dp:ClientKeybindGet", src, "num4", "", "num5", "", "num6", "", "num7", "", "num8", "", "num8", "") end)
	end)

	RegisterServerEvent("dp:ServerKeybindGrab")
	AddEventHandler("dp:ServerKeybindGrab", function()
		local src = source local srcid = GetPlayerIdentifier(source)
		MySQL.Async.fetchAll('SELECT keybind1, emote1, keybind2, emote2, keybind3, emote3, keybind4, emote4, keybind5, emote5, keybind6, emote6 FROM `dpkeybinds` WHERE `id` = @id',
		{['@id'] = srcid}, function(kb)
			if kb[1].keybind1 ~= nil then
				TriggerClientEvent("dp:ClientKeybindGet", src, kb[1].keybind1, kb[1].emote1, kb[1].keybind2, kb[1].emote2, kb[1].keybind3, kb[1].emote3, kb[1].keybind4, kb[1].emote4, kb[1].keybind5, kb[1].emote5, kb[1].keybind6, kb[1].emote6)
			else
				TriggerClientEvent("dp:ClientKeybindGet", src, "num4", "", "num5", "", "num6", "", "num7", "", "num8", "", "num8", "")
			end
		end)
	end)

	RegisterServerEvent("dp:ServerKeybindUpdate")
	AddEventHandler("dp:ServerKeybindUpdate", function(key, emote)
		local src = source local myid = GetPlayerIdentifier(source)
		if key == "num4" then chosenk = "keybind1" elseif key == "num5" then chosenk = "keybind2" elseif key == "num6" then chosenk = "keybind3" elseif key == "num7" then chosenk = "keybind4" elseif key == "num8" then chosenk = "keybind5" elseif key == "num9" then chosenk = "keybind6" end
		if chosenk == "keybind1" then
			MySQL.Async.execute("UPDATE dpkeybinds SET emote1=@emote WHERE id=@id", {id = myid, emote = emote}, function() TriggerClientEvent("dp:ClientKeybindGetOne", src, key, emote) end)
		elseif chosenk == "keybind2" then
			MySQL.Async.execute("UPDATE dpkeybinds SET emote2=@emote WHERE id=@id", {id = myid, emote = emote}, function() TriggerClientEvent("dp:ClientKeybindGetOne", src, key, emote) end)
		elseif chosenk == "keybind3" then
			MySQL.Async.execute("UPDATE dpkeybinds SET emote3=@emote WHERE id=@id", {id = myid, emote = emote}, function() TriggerClientEvent("dp:ClientKeybindGetOne", src, key, emote) end)
		elseif chosenk == "keybind4" then
			MySQL.Async.execute("UPDATE dpkeybinds SET emote4=@emote WHERE id=@id", {id = myid, emote = emote}, function() TriggerClientEvent("dp:ClientKeybindGetOne", src, key, emote) end)
		elseif chosenk == "keybind5" then
			MySQL.Async.execute("UPDATE dpkeybinds SET emote5=@emote WHERE id=@id", {id = myid, emote = emote}, function() TriggerClientEvent("dp:ClientKeybindGetOne", src, key, emote) end)
		elseif chosenk == "keybind6" then
			MySQL.Async.execute("UPDATE dpkeybinds SET emote6=@emote WHERE id=@id", {id = myid, emote = emote}, function() TriggerClientEvent("dp:ClientKeybindGetOne", src, key, emote) end)
		end
	end)
  end)
else
	print("[dp] ^3Sql Keybinding^7 is turned ^1off^7, if you want to enable /emotebind, import dpkeybinding.sql and set ^3SqlKeybinding = ^2true^7 in config.lua.")
end
