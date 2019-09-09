local permission = {
	kick = 1,
	ban = 4
}

local noNotifications = {}

local WEBHOOK_URL = 'https://discordapp.com/api/webhooks/618094684849438730/ZN0KzS3EZfRU3Tyt4jn09ehK82BqXK_dtrTLkF2wRqq0b9lj-c4IafZtSiBK5BqlEJ5L'

-- Adding custom groups called owner, inhereting from superadmin. (It's higher then superadmin). And moderator, higher then user but lower then admin
TriggerEvent("es:addGroup", "owner", "superadmin", function(group) end)
TriggerEvent("es:addGroup", "superadmin", "admin", function(group) end)
TriggerEvent("es:addGroup", "admin", "mod", function(group) end)
TriggerEvent("es:addGroup", "mod", "user", function(group) end)

-- staff pvt msg someone
TriggerEvent('es:addGroupCommand', 'whisper', 'mod', function(source, args, char)
	local target = tonumber(args[2])
	table.remove(args, 1)
	table.remove(args, 1)
	local message = table.concat(args, " ")
	if GetPlayerName(target) then
		TriggerClientEvent('chatMessage', target, "", {90, 90, 60}, "^2^*[WHISPER]^0^r " .. GetPlayerName(source) ..':^2 '.. message)
		TriggerClientEvent('es_admin:notifySound', target)
		TriggerEvent("es:getPlayers", function(players)
			if players then
				for id, player in pairs(players) do
					if id and player then
						local playerGroup = player.getGroup()
						if playerGroup == "owner" or playerGroup == "superadmin" or playerGroup == "admin" or playerGroup == "mod" and NotifyStaff(source) then
							TriggerClientEvent('chatMessage', id, "", {90, 90, 60}, "^2^*[WHISPER]^0^r "..GetPlayerName(source).." to " .. GetPlayerName(target) .. ": ^2".. message)
						end
					end
				end
			end
		end)
	end
end, {
	help = "Send a message directly to a player.",
	params = {
		{ name = "id", help = "Player's id" },
		{ name = "message", help = "Staff message to player" }
	}
})

TriggerEvent('es:addGroupCommand', 'togglestaff', 'mod', function(source, args, char)
	if NotifyStaff(source) then
		table.insert(noNotifications, source)
		TriggerClientEvent('usa:notify', source, 'Staff actions and chat muted.')
	else
		for i = 1, #noNotifications do
			if noNotifications[i] == source then
				table.remove(noNotifications, i)
				TriggerClientEvent('usa:notify', source, 'Staff actions and chat unmuted.')
			end
		end
	end
end, {
	help = "Toggle staff chat and action notifications."
})

--[[TriggerEvent('es:addGroupCommand', 'vanish', 'mod', function(source, args, user)
	TriggerEvent("es:getPlayers", function(players)
		if players then
			for id, player in pairs(players) do
				if id and player then
					local playerGroup = player.getGroup()
					if (playerGroup == "owner" or playerGroup == "superadmin" or playerGroup == "admin" or playerGroup == "mod") and NotifyStaff(source) then
						TriggerClientEvent("chatMessage", id, "", {}, "^2^*[STAFF]^0^r ".. GetPlayerName(staffId) .." [#"..staffId.."]:^1 " .. message)
						--TriggerClientEvent("chatMessage", id, "", {}, "^2MESSAGE:^0 " .. message)
					end
				end
			end
		end
	end)
end, {
	help = "Become invisible to non-staff members."
})]]

-- staff chat
TriggerEvent('es:addGroupCommand', 'a', 'mod', function(source, args, char)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local userGroup = user.getGroup()
	local staffId = tonumber(source)
	table.remove(args, 1) -- remove "/staff" from what the user enters into chat box
	local message = table.concat(args, " ") -- get all the remaining words separated by spaces the user enters into chat box
	TriggerEvent("es:getPlayers", function(players)
		if players then
			for id, player in pairs(players) do
				if id and player then
					local playerGroup = player.getGroup()
					if (playerGroup == "owner" or playerGroup == "superadmin" or playerGroup == "admin" or playerGroup == "mod") and NotifyStaff(source) then
						TriggerClientEvent("chatMessage", id, "", {}, "^2^*[STAFF]^0^r ".. GetPlayerName(staffId) .." [#"..staffId.."] ^r^2 MESSAGE:^0 " .. message)
						--TriggerClientEvent("chatMessage", id, "", {}, "^2MESSAGE:^0 " .. message)
					end
				end
			end
		end
	end)
end, {
	help = "Talk to other staff members directly.",
	params = {
		{ name = "message", help = "Message to send" }
	}
})

TriggerEvent('es:addGroupCommand', 'staff', 'mod', function(source, args, char)
	local user = exports["essentialmode"]:getPlayerFromId(source)
	local userGroup = user.getGroup()
	local staffId = tonumber(source)
	table.remove(args, 1) -- remove "/staff" from what the user enters into chat box
	local message = table.concat(args, " ") -- get all the remaining words separated by spaces the user enters into chat box
	TriggerEvent("es:getPlayers", function(players)
		if players then
			for id, player in pairs(players) do
				if id and player then
					local playerGroup = player.getGroup()
					if (playerGroup == "owner" or playerGroup == "superadmin" or playerGroup == "admin" or playerGroup == "mod") and NotifyStaff(source) then
						TriggerClientEvent("chatMessage", id, "", {}, "^2^*[STAFF]^0^r ".. GetPlayerName(staffId) .." [#"..staffId.."] ^r^2 MESSAGE:^0 " .. message)
					end
				end
			end
		end
	end)
end, {
	help = "Talk to other staff members directly.",
	params = {
		{ name = "message", help = "Message to send" }
	}
})

TriggerEvent('es:addCommand', 'report', function(source, args, char)
	local reporterId = tonumber(source)
	local reportedId = args[2]
	table.remove(args, 1)
	table.remove(args, 1)
	local message = table.concat(args, " ")
	if not message or not reportedId then
		TriggerClientEvent("chatMessage", tonumber(source), "", {}, "^3^*[REPORT]^r Usage: ^0/report [message]")
		return
	end
	TriggerClientEvent("chatMessage", source, "", {}, "^3Your report:^0 ".. reportedId .. " " .. message)
	TriggerEvent("es:getPlayers", function(players)
		if players then
			for id, player in pairs(players) do
				if id and player then
					local playerGroup = player.getGroup()
					if playerGroup == "owner" or playerGroup == "superadmin" or playerGroup == "admin" or playerGroup == "mod" then
						--TriggerClientEvent("chatMessage", id, "", {}, "^3****")
						TriggerClientEvent("chatMessage", id, "", {}, "^3^*[REPORT]^r^0 "..GetPlayerName(reporterId).." [#"..reporterId.."] ^3^*|^r^0 " .. reportedId .. " " .. message)
						--TriggerClientEvent("chatMessage", id, "", {}, "^3MESSAGE:^0 " .. reportedId .. " " .. message)
						--TriggerClientEvent("chatMessage", id, "", {}, "^3****")
					end
				end
			end
		end
	end)
end, {
	help = "Report players or issues for immediate assistance ONLY.",
	params = {
		{ name = "message", help = "Reason for report" }
	}
})

TriggerEvent('es:addCommand', 'help', function(source, args, char)
	table.remove(args, 1)
	if #args > 0 then
		local message = table.concat(args, " ")
		if not message then
			TriggerClientEvent("chatMessage", tonumber(source), "", {}, "^3Usage: ^0/help [message]")
			return
		end
		TriggerEvent("es:getPlayers", function(players)
			if players then
				for id, player in pairs(players) do
					if id and player then
						local playerGroup = player.getGroup()
						if playerGroup == "owner" or playerGroup == "superadmin" or playerGroup == "admin" or playerGroup == "mod" then
							TriggerClientEvent("chatMessage", id, "", {}, "^6^*[HELP]^r^0 " .. GetPlayerName(source) .. " [#" .. source .. "] ^6^*|^r^0 " .. message)
						end
					end
				end
			end
		end)
	else
		TriggerClientEvent("chatMessage", tonumber(source), "", {}, "^3Usage: ^0/help [message]")
	end
end, {
	help = "A way to ask staff for support or help",
	params = {
		{ name = "message", help = "Your message to the support team" }
	}
})

-- Append a message
function appendNewPos(msg)
	local file = io.open('resources/[usa_overhaul]/es_admin/positions.txt', "a")
	newFile = msg
	file:write(newFile)
	file:flush()
	file:close()
end

-- Do them hashes
function doHashes()
  lines = {}
  for line in io.lines("resources/[usa_overhaul]/es_admin/input.txt") do
  	lines[#lines + 1] = line
  end

  return lines
end


RegisterServerEvent('es_admin:givePos')
AddEventHandler('es_admin:givePos', function(str)
	appendNewPos(str)
end)

-- Noclip
TriggerEvent('es:addGroupCommand', 'noclip', "mod", function(source, args, char)
	TriggerClientEvent("es_admin:noclip", source, GetPlayerName(source))
end, {
	help = "Move freely around the map."
})

RegisterServerEvent('admin:checkGroupForNoClipHotkey')
AddEventHandler('admin:checkGroupForNoClipHotkey', function()
	local user = exports["essentialmode"]:getPlayerFromId(source)
	if user.getGroup() ~= "user" then
		TriggerClientEvent("es_admin:noclip", source, GetPlayerName(source))
	end
end)

-- Kicking
TriggerEvent('es:addGroupCommand', 'kick', "mod", function(source, args, char)
	local userSource = source
	if(GetPlayerName(tonumber(args[2])))then
		local player = tonumber(args[2])
		local target = exports["usa-characters"]:GetCharacter(player)
		local reason = args
		table.remove(reason, 1)
		table.remove(reason, 1)
		if(#reason == 0)then
			reason = "kicked"
		else
			reason = table.concat(reason, " ")
		end
		-- send discord message
		local targetPlayerName = target.getFullName()
		local allPlayerIdentifiers = GetPlayerIdentifiers(player)
		-- send discord message
		local desc = "**Character Name:** " .. targetPlayerName
		desc = desc .. "\n**Steam Name:** " .. GetPlayerName(player)
		for i = 1, #allPlayerIdentifiers do
			desc = desc .. " \n**Identifier #"..i..":** " .. allPlayerIdentifiers[i]
		end
		desc = desc .. " \n**Reason:** " ..reason:gsub("Kicked: ", "").. " \n**Kicked By:** "..GetPlayerName(userSource).."\n**Timestamp:** "..os.date('%m-%d-%Y %H:%M:%S', os.time())
		PerformHttpRequest(WEBHOOK_URL, function(err, text, headers)
			if text then
				print(text)
			end
		end, "POST", json.encode({
			embeds = {
				{
					description = desc,
					color = 16777062,
					author = {
						name = "User Kicked From The Server"
					}
				}
			}
		}), { ["Content-Type"] = 'application/json' })

		sendMessageToModsAndAdmins(userSource, GetPlayerName(player) .. " has been kicked (" .. reason .. ")")
		--TriggerClientEvent('chatMessage', -1, "", {255, 255, 255}, targetPlayerName .. " has been ^3kicked^0 (" .. reason .. ")")
		DropPlayer(player, reason)
	else
		TriggerClientEvent('usa:notify', source, 'Player not found!')
	end
end, {
	help = "Kick a player.",
	params = {
		{ name = "id", help = "Player's ID" },
		{ name = "message", help = "Reason for the kick (INCLUDE YOUR NAME)" }
	}
})

function stringsplit(self, delimiter)
  local a = self:Split(delimiter)
  local t = {}

  for i = 0, #a - 1 do
	 table.insert(t, a[i])
  end

  return t
end

-- Announcing
TriggerEvent('es:addGroupCommand', 'announce', "mod", function(source, args, char)
	table.remove(args, 1)
	TriggerClientEvent('chatMessage', -1, "", {255, 0, 0}, "^2^*[STAFF ANNOUNCEMENT] ^r^0" .. table.concat(args, " "))
end, {
	help = "Send a server-wide message.",
	params = {
		{ name = "message", help = "message to send" }
	}
})

-- Freezing
local frozen = {}
TriggerEvent('es:addGroupCommand', 'freeze', "mod", function(source, args, char)
	if(GetPlayerName(tonumber(args[2])))then
		local player = tonumber(args[2])
		if(frozen[player])then
			frozen[player] = false
		else
			frozen[player] = true
		end
		TriggerClientEvent('es_admin:freezePlayer', player, frozen[player])
		local state = "unfrozen"
		if(frozen[player])then
			state = "frozen"
		end
		TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(player)..' ['..player..'] ^0 has been '..state..' by ^2'..GetPlayerName(source)..' ['..source..']^0.')
		TriggerClientEvent('chatMessage', player, '^2^*[STAFF]^r^0 You have been '..state..'.')
	else
		TriggerClientEvent('usa:notify', source, 'Player not found!')
	end
end, {
	help = "Freeze a player.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

-- Bring
TriggerEvent('es:addGroupCommand', 'bring', "mod", function(source, args, char)
	if(GetPlayerName(tonumber(args[2])))then
		local player = tonumber(args[2])
		TriggerClientEvent('es_admin:teleportUser', player, source)
		TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(player)..' ['..player..'] ^0 has been brought to ^2'..GetPlayerName(source)..' ['..source..']^0.')
		TriggerClientEvent('chatMessage', player, '^2^*[STAFF]^r^0 You have been teleported.')
	else
		TriggerClientEvent('usa:notify', source, 'Player not found!')
	end
end, {
	help = "Bring a player.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

TriggerEvent('es:addGroupCommand', 'slap', "admin", function(source, args, char)
	if(GetPlayerName(tonumber(args[2])))then
		local player = tonumber(args[2])
		TriggerClientEvent('es_admin:slap', player)
		TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(player)..' ['..player..'] ^0 has been slapped by ^2'..GetPlayerName(source)..' ['..source..']^0.')
		TriggerClientEvent('chatMessage', player, '^2^*[STAFF]^r^0 You have been slapped.')
	else
		TriggerClientEvent('usa:notify', source, 'Player not found!')
	end
end, {
	help = "Slap a player / Make them fly into the air (TROLL DO NOT USE IN RP)",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

------------------------------
-- go to any coordinate --
------------------------------
TriggerEvent('es:addGroupCommand', 'gotoc', "mod", function(source, args, char)
	TriggerClientEvent('es_admin:teleportUserByCoords', source, tonumber(args[2]), tonumber(args[3]), tonumber(args[4]))
	TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(source)..' ['..source..'] ^0 has teleported to coordinates: '..args[2]..', '..args[3]..', '..args[4]..'.')
end, {
	help = "Go to specified coordinate",
	params = {
		{ name = "X", help = "X coordinate" },
		{ name = "Y", help = "Y coordinate" },
		{ name = "Z", help = "Z coordinate" }
	}
})

TriggerEvent('es:addGroupCommand', 'goto', "mod", function(source, args, char)
	if args[2] == "pd" then
		local pdCoords = {x = -444.5, y = 6013.9, z = 31.7}
		TriggerClientEvent('es_admin:teleportUserByCoords', source, pdCoords.x, pdCoords.y, pdCoords.z)
		TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(source)..' ['..source..'] ^0 has teleported to a police department.')
		return
	elseif args[2] == "c" or args[2] == "coords" then
		TriggerClientEvent('es_admin:teleportUserByCoords', source, tonumber(args[3]), tonumber(args[4]), tonumber(args[5]))
		TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(source)..' ['..source..'] ^0 has teleported to coordinates: '..args[3]..', '..args[4]..', '..args[5]..'.')
		return
	elseif args[2] == "wp" then
		TriggerClientEvent("swayam:gotoWP", source)
		TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(source)..' ['..source..'] ^0 has teleported to waypoint.')
		return
	elseif args[2] == "fd" then
		local fdCoords = {x=-366.30380249023, y=6102.0532226563, z=35.439697265625}
		TriggerClientEvent('es_admin:teleportUserByCoords', source, fdCoords.x, fdCoords.y, fdCoords.z)
		TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(source)..' ['..source..'] ^0 has teleported to a fire department.')
		return
	end
	if tonumber(args[2]) ~= nil then
		if GetPlayerName(tonumber(args[2])) then
			local player = tonumber(args[2])
				local target = exports["essentialmode"]:getPlayerFromId(player)

				if (target) then

					TriggerClientEvent('es_admin:teleportUser', source, player)

					TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(source)..' ['..source..'] ^0 has teleported to ^2'..GetPlayerName(player)..' ['..player..']^0.')
					TriggerClientEvent('chatMessage', player, '^2^*[STAFF]^r^0 You have been teleported to.')

				end
		else
			TriggerClientEvent('usa:notify', source, 'Player not found!')
		end
	end
end, {
	help = "Teleport to player or location.",
	params = {
		{ name = "id", help = "Player's ID or warp ID" }
	}
})

-- Kill yourself
TriggerEvent('es:addCommand', 'die', function(source, args, char)
	TriggerClientEvent('es_admin:kill', source)
end, {
	help = "Commit suicide."
})

-- Killing
TriggerEvent('es:addGroupCommand', 'slay', "admin", function(source, args, char)
	if(GetPlayerName(tonumber(args[2])))then
		local player = tonumber(args[2])
		TriggerClientEvent('es_admin:kill', player)
		TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(player)..' ['..player..'] ^0 has been killed by ^2'..GetPlayerName(source)..' ['..source..']^0.')
		TriggerClientEvent('chatMessage', player, '^2^*[STAFF]^r^0 You have been killed.')
	else
		TriggerClientEvent('usa:notify', source, 'Player not found!')
	end
end, {
	help = "Kill a player.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

-- Crashing
TriggerEvent('es:addGroupCommand', 'crash', "superadmin", function(source, args, char)
	if(GetPlayerName(tonumber(args[2])))then
		local player = tonumber(args[2])
		TriggerClientEvent('es_admin:crash', player)
		TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(player)..' ['..player..'] ^0 has been crashed by ^2'..GetPlayerName(source)..' ['..source..']^0.')
	else
		TriggerClientEvent('usa:notify', source, 'Player not found!')
	end
end, {
	help = "Crash a player's game.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

-- Position
TriggerEvent('es:addGroupCommand', 'pos', "owner", function(source, args, char)
	TriggerClientEvent('es_admin:givePosition', source)
end, {
	help = "Save pos to txt"
})

TriggerEvent('es:addGroupCommand', 'car', 'superadmin', function(source, args, char)
	TriggerClientEvent('es_admin:spawnVehicle', source, args[2])
	TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(source)..' ['..source..'] ^0 has requested to spawn vehicle: ^2'..args[2]..'^0.')
end, {
	help = "Spawn a car (not to be abused, we are watching..)",
	params = {
		{ name = "model", help = "Model of the car" }
	}
})

TriggerEvent('es:addGroupCommand', 'spectate', 'mod', function(source, args, char)
	local userSource = tonumber(source)
	local targetPlayer = tonumber(args[2])
	if not targetPlayer then return end
	TriggerClientEvent("mini_admin:spectate", userSource, targetPlayer, GetPlayerName(targetPlayer), GetPlayerName(userSource))
end, {
	help = "Spectate a player.",
	params = {
		{ name = "id", help = "Player's ID" }
	}
})

-- Rcon commands
AddEventHandler('rconCommand', function(commandName, args)
	if commandName == "unban" then
		-- identifier argument --
		local identifierToUnban = args[1]
		RconPrint("\nlooking to unban: " .. identifierToUnban)
		-- valid input check --
		if not identifierToUnban then RconPrint("\nUsage: unban [identifier] ") CancelEvent() return end
		-- Search for banned doc with that identifier --
		TriggerEvent('es:exposeDBFunctions', function(couchdb)
			local query = {
				["identifiers"] = {
					["$elemMatch"] = {
						["$regex"] = "(?i)" .. identifierToUnban
					}
				}
			}
			local fields = {
				"_id",
				"_rev",
				"name"
			}
			couchdb.getSpecificFieldFromDocumentByRows("bans", query, fields, function(doc)
				if doc then
					--print(doc.name .. " found in DB search!")
					PerformHttpRequest("http://127.0.0.1:5984/bans/".. doc._id .. "?rev=" .. doc._rev, function(err, rText, headers)
						--RconPrint("\nrText = " .. rText)
						RconPrint("\nResponse Code = " .. err)
						if tonumber(err) == 200 then
							RconPrint("\nBan successfully removed!")
						else
							RconPrint("\nSomething might have gone wrong, response code was: " .. err)
						end
					end, "DELETE", "", {["Content-Type"] = 'application/json'})
				else
					RconPrint("\nIdentifier NOT found!")
				end
			end)
		end)
		CancelEvent()
	elseif commandName == "freeze" then
		if(GetPlayerName(tonumber(args[1])))then
			local player = tonumber(args[1])
			if(frozen[player])then
				frozen[player] = false
			else
				frozen[player] = true
			end

			TriggerClientEvent('es_admin:freezePlayer', player, frozen[player])

			local state = "unfrozen"
			if(frozen[player])then
				state = "frozen"
			end
			RconPrint("You froze player " .. GetPlayerName(player) .. ".")
			TriggerClientEvent('chatMessage', player, '^2^*[STAFF]^r^0 You have been '..state..' by ^2^*console^r^0.')
			TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(player)..' ['..player..'] ^0 has been '..state..' by ^2^*console^r^0.')
		else
			RconPrint("INVALID PLAYER ID!")
		end
	elseif commandName == "ban" then
		RconPrint("BAN COMMAND CALLED FROM RCON!")
		if #args < 2 then
			RconPrint("Usage: ban [user-id] [reason]\n")
			CancelEvent()
			return
		end
		RconPrint("banning player = " .. GetPlayerName(tonumber(args[1])))
		RconPrint("\nid = " .. args[1])
		-- ban player
		TriggerEvent('es:exposeDBFunctions', function(GetDoc)
			-- get info from command
			local banner = "console"
			local bannerId = "console"
			local targetPlayer = tonumber(args[1])
			local targetPlayerName = GetPlayerName(targetPlayer)
			table.remove(args, 1) -- remove id
			local reason = table.concat(args, " ")
			local allPlayerIdentifiers = GetPlayerIdentifiers(targetPlayer)
			RconPrint("\nPlayer Identifiers:")
			for i = 1, #allPlayerIdentifiers do
				RconPrint("\n#"..i..": " .. allPlayerIdentifiers[i])
			end
			-- show message
			RconPrint(targetPlayerName .. " has been banned (" .. reason .. ")")
			--TriggerClientEvent('chatMessage', -1, "", {255, 255, 255}, targetPlayerName .. " has been ^2banned^0 (" .. reason .. ")")
			sendMessageToModsAndAdmins(0, targetPlayerName .. " has been ^1banned^0 (" .. reason .. ")")
			-- character name:
			local player = exports["usa-characters"]:GetCharacter(targetPlayer)
			local char_name = player.getFullName()
			-- send discord message
			local desc = "**Character Name:** " .. char_name
			desc = desc .. "\n**Steam Name:** " .. targetPlayerName
			for i = 1, #allPlayerIdentifiers do
				desc = desc .. " \n**Identifier #"..i..":** " .. allPlayerIdentifiers[i]
			end
			desc = desc .. " \n**Reason:** " ..reason:gsub("Banned: ", "").. " \n**Banned By:** Console\n**Timestamp:** "..os.date('%m-%d-%Y %H:%M:%S', os.time())
				PerformHttpRequest(WEBHOOK_URL, function(err, text, headers)
					if text then
						print(text)
					end
				end, "POST", json.encode({
					embeds = {
						{
							description = desc,
							color = 14750740,
							author = {
								name = "User Banned From The Server"
							}
						}
					}
				}), { ["Content-Type"] = 'application/json' })
			-- update db
			GetDoc.createDocument("bans",  {char_name = char_name, name = targetPlayerName, identifiers = allPlayerIdentifiers, banned = true, reason = reason, bannerName = banner, bannerId = bannerId, timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())}, function()
				RconPrint("player banned!")
				DropPlayer(targetPlayer, "Banned: " .. reason)
			end)
		end)
	elseif commandName == "banid" then
		-- see if input was correct --
		if #args < 4 then
			RconPrint("Usage: banid [steam:123456789] [first name] [last name] [reason]\n")
			CancelEvent()
			return
		end
		-- enter player into ban table --
		TriggerEvent('es:exposeDBFunctions', function(GetDoc)
			-- get info from command
			local banner = "console"
			local bannerId = "console"
			local targetPlayer = args[1]
			local allPlayerIdentifiers = {}
			table.insert(allPlayerIdentifiers, targetPlayer)
			local targetPlayerName = args[2] .. " " .. args[3]
			table.remove(args, 1) -- remove id
			table.remove(args, 1) -- remove fname
			table.remove(args, 1) -- remove lname
			local reason = table.concat(args, " ")
			RconPrint("\nPlayer Identifier: " .. targetPlayer .. "\n")
			-- show message
			RconPrint(targetPlayerName .. " has been banned (" .. reason .. ")")
			--TriggerClientEvent('chatMessage', -1, "", {255, 255, 255}, targetPlayerName .. " has been ^1banned^0 (" .. reason .. ")")
			sendMessageToModsAndAdmins(0, targetPlayerName .. " has been ^1banned^0 (" .. reason .. ").")
			-- update db --
			GetDoc.createDocument("bans",  {char_name = "?", name = targetPlayerName, identifiers = allPlayerIdentifiers, banned = true, reason = reason, bannerName = banner, bannerId = bannerId, timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())}, function()
				RconPrint("player banned!")
				-- send discord message --
				local desc = "\n**Name:** " .. targetPlayerName
				desc = desc .. "\n**Identifier:** " .. targetPlayer
				desc = desc .. " \n**Reason:** " ..reason:gsub("Banned: ", "").. " \n**Banned By:** Console\n**Timestamp:** "..os.date('%m-%d-%Y %H:%M:%S', os.time())
				PerformHttpRequest(WEBHOOK_URL, function(err, text, headers)
					if text then
						print(text)
					end
				end, "POST", json.encode({
					embeds = {
						{
							description = desc,
							color = 14750740,
							author = {
								name = "User Banned From The Server"
							}
						}
					}
				}), { ["Content-Type"] = 'application/json' })
			end)
		end)
	elseif commandName == "tempbanid" then
		-- see if input was correct --
		if #args < 4 then
			RconPrint("Usage: tempbanid [steam:123456789] [time] [first name] [last name] [reason]\n")
			RconPrint("Note: if you don't know the first or last name just put an 'x' or '?' in place of it\n")
			CancelEvent()
			return
		end
		-- enter player into ban table --
		TriggerEvent('es:exposeDBFunctions', function(GetDoc)
			-- get info from command
			local banner = "console"
			local bannerId = "console"
			local targetPlayer = args[1]
			local time = tonumber(args[2])
			local allPlayerIdentifiers = {}
			table.insert(allPlayerIdentifiers, targetPlayer)
			local targetPlayerName = args[3] .. " " .. args[4]
			table.remove(args, 1) -- remove id
			table.remove(args, 1) -- remove time
			table.remove(args, 1) -- remove fname
			table.remove(args, 1) -- remove lname
			local reason = table.concat(args, " ")
			RconPrint("\nPlayer Identifier: " .. targetPlayer .. "\n")
			-- show message
			RconPrint(targetPlayerName .. " has been banned (" .. reason .. ")")
			--TriggerClientEvent('chatMessage', -1, "", {255, 255, 255}, targetPlayerName .. " has been ^1banned^0 (" .. reason .. ")")
			sendMessageToModsAndAdmins(0, targetPlayerName .. " has been ^1banned^0 (" .. reason .. ").")
			-- update db --
			GetDoc.createDocument("bans",  {time = os.time(), duration = time, char_name = "?", name = targetPlayerName, identifiers = allPlayerIdentifiers, banned = true, reason = reason, bannerName = banner, bannerId = bannerId, timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())}, function()
				RconPrint("player banned!")
				-- send discord message --
				local desc = "\n**Name:** " .. targetPlayerName
				desc = desc .. "\n**Identifier:** " .. targetPlayer
				desc = desc .. " \n**Time:** " .. time .. " hour(s)"
				desc = desc .. " \n**Reason:** " ..reason:gsub("Temp Banned: ", "").. " \n**Banned By:** Console\n**Timestamp:** "..os.date('%m-%d-%Y %H:%M:%S', os.time())
				PerformHttpRequest(WEBHOOK_URL, function(err, text, headers)
					if text then
						print(text)
					end
				end, "POST", json.encode({
					embeds = {
						{
							description = desc,
							color = 14750740,
							author = {
								name = "User Temp Banned From The Server"
							}
						}
					}
				}), { ["Content-Type"] = 'application/json' })
			end)
		end)
	elseif commandName == 'setadmin' then
		if #args ~= 2 then
			RconPrint("Usage: setadmin [user-id] [permission-level]\n")
			CancelEvent()
			return
		end

		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Player not ingame\n")
			CancelEvent()
			return
		end

		TriggerEvent("es:setPlayerData", tonumber(args[1]), "permission_level", tonumber(args[2]), function(response, success)
			RconPrint(response)

			if(true)then
				print(args[1] .. " " .. args[2])
				TriggerClientEvent('es:setPlayerDecorator', tonumber(args[1]), 'rank', tonumber(args[2]), true)
				TriggerClientEvent('chatMessage', -1, "", {255, 255, 255}, "^2^*[SERVER]^r^0 Permission level of ^2^*" .. GetPlayerName(tonumber(args[1])) .. "^r^0 has been set to ^2^* " .. args[2]..'^r^0.')
			end
		end)

		CancelEvent()
	elseif commandName == 'setgroup' then
		if #args ~= 2 then
			RconPrint("Usage: setgroup [user-id] [group]\n")
			CancelEvent()
			return
		end

		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Player not ingame\n")
			CancelEvent()
			return
		end

		TriggerEvent("es:getAllGroups", function(groups)

			if(groups[args[2]])then
				TriggerEvent("es:setPlayerData", tonumber(args[1]), "group", args[2], function(response, success)
					RconPrint(response)

					if(true)then
						print(args[1] .. " " .. args[2])
						TriggerClientEvent('es:setPlayerDecorator', tonumber(args[1]), 'group', tonumber(args[2]), true)
						TriggerClientEvent('chatMessage', -1, "", {255, 255, 255}, "^2^*[SERVER] ^r^0Group of ^2^*" .. GetPlayerName(tonumber(args[1])) .. "^r^0 has been set to ^2^*" .. args[2]..'^r^0.')
					end
				end)
			else
				RconPrint("This group does not exist.\n")
			end
		end)
	elseif commandName == 'setmoney' then
		if #args ~= 2 then
			RconPrint("Usage: setmoney [user-id] [money]\n")
			CancelEvent()
			return
		end

		if(GetPlayerName(tonumber(args[1])) == nil)then
			RconPrint("Player not ingame\n")
			CancelEvent()
			return
		end

		local char = exports["usa-characters"]:GetCharacter(tonumber(args[1]))
		if char then
			char.set("money", tonumber(args[2]))
			RconPrint("Money set")
			TriggerClientEvent('chatMessage', args[1], "", {255, 255, 255}, "^2^*[SERVER] ^r^0Your money has been set to ^2^*" .. args[2]..'^r^0.')
			TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Money of ^2'..GetPlayerName(args[1])..' ['..args[1]..'] ^0 has been set to ^2^*'..args[2]..'^r^0 by ^2^*console^r^0.')
		end
	elseif commandName == "addmoney" or commandName == "givemoney" then
		if #args ~= 2 then
			RconPrint("Usage: setmoney [user-id] [money]\n")
			CancelEvent()
			return
		end

		local targetId = tonumber(args[1])
		local amount = tonumber(args[2])

		if not GetPlayerName(targetId) then
			RconPrint("Player not in game\n")
			CancelEvent()
			return
		end

		-- give and save money --
		local user = exports["usa-characters"]:GetCharacter(targetId)
		user.giveMoney(amount)
		TriggerClientEvent('chatMessage', targetId, "", {255, 255, 255}, "^2^*[SERVER] ^r^0You have received ^2^*" .. amount..'^r^0.')
		TriggerEvent("usa:notifyStaff", '^2^*[STAFF]^r^0 Player ^2'..GetPlayerName(targetId)..' ['..targetId..'] ^0 has received ^2^*'..amount..'^r^0 money from ^2^*console^r^0.')
		RconPrint("Money given")
	elseif commandName == "changename" then
			if #args ~= 6 and #args ~= 5 then
				RconPrint("\nUsage: changename [prevFirst] [prevLast] [DOB] [newFirst] [newMiddle] [newLast] -> Full Name Change")
				RconPrint("\nOR")
				RconPrint("\nchangename [prevFirst] [prevLast] [DOB] [newFirst] [newLast] -> No Middle Name Change")
				RconPrint("\nDOB must be in YYYY-MM-DD format, i.e. 1980-01-15")
				CancelEvent()
				return
			end

			local prevFirst
			local prevLast
			local dob
			local newFirst
			local newMiddle
			local newLast

			if #args == 6 then
				prevFirst = args[1]
				prevLast = args[2]
				dob = args[3]
				newFirst = args[4]
				newMiddle = args[5]
				newLast = args[6]
			else
				prevFirst = args[1]
				prevLast = args[2]
				dob = args[3]
				newFirst = args[4]
				newLast = args[5]
			end

			local query = {
				["firstName"] = {
					["$regex"] = "(?i)" .. prevFirst
				},
				["lastName"] = {
					["$regex"] = "(?i)" .. prevLast
				},
				["dateOfBirth"] = dob
			}

			-- search for player's document in DB --
			TriggerEvent('es:exposeDBFunctions', function(couchdb)
				local fields = {
					"_id",
					"_rev"
				}
				couchdb.getSpecificFieldFromDocumentByRows("characters", query, fields, function(doc)
					if doc then
						doc.name.first = newFirst
						doc.name.middle = newMiddle
						doc.name.last = newLast
						-- update --
						couchdb.updateDocument("characters", doc._id, {name = doc.name}, function()
							RconPrint("Name updated in DB!")
						end)
					else
						RconPrint("\nError: unable to find person ".. prevFirst .. " " .. (prevMiddle or "") .. " " .. prevLast .. " in database!")
					end
				end)
			end)
		elseif commandName == "changedob" then
			if #args ~= 4 then
				RconPrint("\nUsage: changedob [firstName] [lastName] [prevDOB] [newDOB]")
				RconPrint("\nDOB must be in YYYY-MM-DD format, i.e. 1980-01-15")
				CancelEvent()
				return
			end

			local prevFirst = args[1]
			local prevLast = args[2]
			local prevDob = args[3]
			local newDob = args[4]

			local query = {
				["firstName"] = {
					["$regex"] = "(?i)" .. prevFirst
				},
				["lastName"] = {
					["$regex"] = "(?i)" .. prevLast
				},
				["dateOfBirth"] = prevDob
			}

			-- search for player's document in DB --
			TriggerEvent('es:exposeDBFunctions', function(couchdb)
				local fields = {
					"_id",
					"_rev"
				}
				couchdb.getSpecificFieldFromDocumentByRows("characters", query, fields, function(doc)
					if doc then
						couchdb.updateDocument("characters", doc._id, {dateOfBirth = newDOB}, function()
							RconPrint("DOB updated in DB!")
						end)
					else
						RconPrint("\nError: unable to find person ".. prevFirst .. " " .. (prevMiddle or "") .. " " .. prevLast .. " in database!")
					end
				end)
			end)
		end
	CancelEvent()
end)

--------------- BAN MANAGEMENT: -------------------
-- PERFORM FIRST TIME DB CHECK --
exports["globals"]:PerformDBCheck("BANS", "bans", fetchAllBans)

-- ban command --
TriggerEvent('es:addGroupCommand', 'ban', "admin", function(source, args, char)
	local userSource = tonumber(source)
	-- add player to ban list
	TriggerEvent('es:exposeDBFunctions', function(GetDoc)
		-- get info from command
		local banner = GetPlayerName(userSource)
		local bannerId = GetPlayerIdentifiers(userSource)[1]
		local targetPlayer = tonumber(args[2])
		local targetPlayerName = GetPlayerName(targetPlayer)
		table.remove(args,1) -- remove /test
		table.remove(args, 1) -- remove id
		local reason = table.concat(args, " ")
		local allPlayerIdentifiers = GetPlayerIdentifiers(targetPlayer)
		print("#allPlayerIdentifiers = " .. #allPlayerIdentifiers)
		for i = 1, #allPlayerIdentifiers do
			print("allPlayerIdentifiers[i] = " .. allPlayerIdentifiers[i])
		end
		-- show message
		--TriggerClientEvent('chatMessage', -1, "", {255, 255, 255}, GetPlayerName(targetPlayer) .. " has been ^1banned^0 (" .. reason .. ")")
		sendMessageToModsAndAdmins(userSource, GetPlayerName(targetPlayer) .. " has been ^1banned^0 (" .. reason .. ")")
		-- get char name:
		local player = exports["usa-characters"]:GetCharacter(targetPlayer)
		local char_name = player.getFullName()
		local desc = "**Character Name:** " .. char_name
		-- send discord message
		desc = desc .. "\n**Display Name:** " .. targetPlayerName
		for i = 1, #allPlayerIdentifiers do
			desc = desc .. " \n**Identifier #"..i..":** " .. allPlayerIdentifiers[i]
		end
		desc = desc .. " \n**Reason:** " ..reason:gsub("Banned: ", "").. " \n**Banned By:** "..GetPlayerName(userSource).."\n**Timestamp:** "..os.date('%m-%d-%Y %H:%M:%S', os.time())
			PerformHttpRequest(WEBHOOK_URL, function(err, text, headers)
				if text then
					print(text)
				end
			end, "POST", json.encode({
				embeds = {
					{
						description = desc,
						color = 14750740,
						author = {
							name = "User Banned From The Server"
						}
					}
				}
			}), { ["Content-Type"] = 'application/json' })
		-- update db
		GetDoc.createDocument("bans",  {char_name = char_name, name = targetPlayerName, identifiers = allPlayerIdentifiers, banned = true, reason = reason, bannerName = banner, bannerId = bannerId, timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())}, function()
			print("player banned!")
			-- drop player from session
			--print("banning player with endpoint: " .. GetPlayerEP(targetPlayer))
			DropPlayer(targetPlayer, "Banned: " .. reason .. " -- You can file an appeal at https://usarrp.net")
		end)
	end)
end, {
	help = "CAUTION: ONLY USE FOR SERIOUS OFFENSES. Please consider using /tempban instead.",
	params = {
		{ name = "id", help = "Player's ID" },
		{ name = "reason", help = "The reason of the ban. Please include as much detail as possible."  }
	}
})

-- temp ban command // Usage: /tempban id time (in hours) reason
TriggerEvent('es:addGroupCommand', 'tempban', "mod", function(source, args, char)
	local userSource = tonumber(source)
	-- add player to ban list
	TriggerEvent('es:exposeDBFunctions', function(GetDoc)
		-- get info from command
		local banner = GetPlayerName(userSource)
		local bannerId = GetPlayerIdentifiers(userSource)[1]
		local targetPlayer = tonumber(args[2])
		local targetPlayerName = GetPlayerName(targetPlayer)
		local time = tonumber(args[3])
		local allPlayerIdentifiers = GetPlayerIdentifiers(targetPlayer)
		table.remove(args,1) -- remove /tempban
		table.remove(args, 1) -- remove id
		table.remove(args, 1) -- remove time
		local reason = table.concat(args, " ")
		local allPlayerIdentifiers = GetPlayerIdentifiers(targetPlayer)
		print("#allPlayerIdentifiers = " .. #allPlayerIdentifiers)
		for i = 1, #allPlayerIdentifiers do
			print("allPlayerIdentifiers[i] = " .. allPlayerIdentifiers[i])
		end
		-- show message
		--TriggerClientEvent('chatMessage', -1, "", {255, 255, 255}, GetPlayerName(targetPlayer) .. " has been ^1banned^0 (" .. reason .. ")")
		sendMessageToModsAndAdmins(userSource, GetPlayerName(targetPlayer) .. " has been ^1temp banned^0 for " .. time .. " hour(s) (" .. reason .. ").")
		-- get char name:
		local player = exports["usa-characters"]:GetCharacter(targetPlayer)
		local char_name = player.getFullName()
		local desc = "**Character Name:** " .. char_name
		-- send discord message
		desc = desc .. "\n**Display Name:** " .. targetPlayerName
		for i = 1, #allPlayerIdentifiers do
			desc = desc .. " \n**Identifier #"..i..":** " .. allPlayerIdentifiers[i]
		end
		desc = desc .. " \n**Time:** " .. time .. " hour(s)"
		desc = desc .. " \n**Reason:** " ..reason:gsub("Banned: ", "").. " \n**Banned By:** "..GetPlayerName(userSource).."\n**Timestamp:** "..os.date('%m-%d-%Y %H:%M:%S', os.time())
			PerformHttpRequest(WEBHOOK_URL, function(err, text, headers)
				if text then
					print(text)
				end
			end, "POST", json.encode({
				embeds = {
					{
						description = desc,
						color = 14750740,
						author = {
							name = "User Temp Banned From The Server"
						}
					}
				}
			}), { ["Content-Type"] = 'application/json' })
		-- update db
		GetDoc.createDocument("bans", {time = os.time(), duration = time, char_name = char_name, name = targetPlayerName, identifiers = allPlayerIdentifiers, banned = true, reason = reason, bannerName = banner, bannerId = bannerId, timestamp = os.date('%m-%d-%Y %H:%M:%S', os.time())}, function()
			print("player banned!")
			-- drop player from session
			--print("banning player with endpoint: " .. GetPlayerEP(targetPlayer))
			DropPlayer(targetPlayer, "Temp Banned: " .. reason .. " This ban is in place for " .. time .. " hour(s).")
		end)
	end)
end, {
	help = "Tempban a player from the server.",
	params = {
		{ name = "id", help = "Player's ID" },
		{ name = "duration", help = "Duration of ban (in hours)" },
		{ name = "reason", help = "The reason of the temp ban. Please include as much detail as possible." }
	}
})

RegisterServerEvent("usa:notifyStaff")
AddEventHandler("usa:notifyStaff", function(msg, src)
	if src then
		source = src
	end
	print("notifying staff")
	sendMessageToModsAndAdmins(source, msg)
end)

RegisterServerEvent('mini:checkPlayerBannedOnSpawn')
AddEventHandler('mini:checkPlayerBannedOnSpawn', function()
	print("checking if loaded player is banned...")
	local usource = source
	--local identifier = GetPlayerIdentifiers(source)[1]
	local allPlayerIdentifiers = GetPlayerIdentifiers(tonumber(usource))
	local gameLicense, steamLicense
	for j = 1, #allPlayerIdentifiers do
		if string.find(allPlayerIdentifiers[j], "license") then
			gameLicense = allPlayerIdentifiers[j]
		elseif string.find(allPlayerIdentifiers[j], "steam") then
			steamLicense = allPlayerIdentifiers[j]
		end
	end
	TriggerEvent('es:exposeDBFunctions', function(couchdb)
		local query = {
			["identifiers"] = {
				["$elemMatch"] = {
					["$or"] = {
						gameLicense, steamLicense
					}
				}
			}
		}
		couchdb.getDocumentByRows("bans", query, function(doc)
			if doc then
				print("found banned player document, name: " .. doc.name)
				if doc.duration then
					if getHoursFromTime(doc.time) < doc.duration then
						print(GetPlayerName(tonumber(usource)) .. " has been temp banned from your server and should not be able to play!")
						DropPlayer(tonumber(usource), "Temp Banned: " .. doc.reason .. " This ban is in place for " .. doc.duration .. " hour(s).")
					else
						local docid = doc._id
						local docRev = doc._rev
						--RconPrint("\nfound a matching identifer to unban for "..bannedPlayer.name.."!")
						-- found a match, unban
						PerformHttpRequest("http://127.0.0.1:5984/bans/" .. docid .. "?rev=" .. docRev, function(err, rText, headers)
							print("\nrText = " .. rText)
							print("\nerr = " .. err)
						end, "DELETE", "", {["Content-Type"] = 'application/json'})
						print("\nPlayer ".. doc.name .." has been unbanned due to tempban expiration!")
						return
					end
				else
					print(GetPlayerName(tonumber(usource)) .. " has been perma banned from your server and should not be able to play!")
					DropPlayer(tonumber(usource), "Banned: " .. doc.reason)
				end
			end
		end)
	end)
end)

TriggerEvent('es:addCommand', 'stats', function(source, args, char)
	if args[2] then
		--admins only
		local group = exports["essentialmode"]:getPlayerFromId(source).getGroup()
		if group == "mod" or group == "admin" or group == "superadmin" or group == "owner" then
			local user = exports["essentialmode"]:getPlayerFromId(tonumber(args[2]))
			local targetchar = exports["usa-characters"]:GetCharacter(tonumber(args[2]))
			if targetchar then
				local ownedVehicles = targetchar.get("vehicles")
				GetMakeModelPlate(ownedVehicles, function(vehs)
					local vehiclenames = ""
					local userVehicles = vehs
					for i = 1, #userVehicles do
						local vehicle = userVehicles[i]
						vehiclenames = vehiclenames .. userVehicles[i].model
						if i ~= #userVehicles then
							vehiclenames = vehiclenames .. ", "
						end
					end
					local weaponnames = ""
					local userWeapons = targetchar.getWeapons()
					for i = 1, #userWeapons do
						local weapon = userWeapons[i]
						weaponnames = weaponnames .. userWeapons[i].name
						if i ~= #userWeapons then
							weaponnames = weaponnames .. ", "
						end
					end
					local inventorynames = ""
					local userInventory = targetchar.get("inventory").items
					for i = 0, char.get("inventory").MAX_CAPACITY - 1 do
						--local inventory = userInventory[i]
						--local quantity = inventory.quantity
						if userInventory[tostring(i)] then
							inventorynames = inventorynames .. userInventory[tostring(i)].name .. "(" .. userInventory[tostring(i)].quantity .. ")"
							inventorynames = inventorynames .. ", "
						end
					end
					local firearms_permit = "Invalid"
					local driving_license = "Invalid"
					local boat_license = "Invalid"
					local bar_license = 'Invalid'
					local plane_license = "Invalid"
					local userLicenses = targetchar.getLicenses()
					for i = 1, #userLicenses do
						local license = userLicenses[i]
						if license.name == "Driver's License"  then
							driving_license = "Valid"
						elseif license.name == "Firearm Permit" then
							firearms_permit = "Valid"
						elseif license.name == "Aircraft License" then
							plane_license = "Valid"
						elseif license.name == "Boat License" then
							boat_license = "Valid"
						elseif license.name == "Bar Certificate" then
							bar_license = "Valid"
						end
					end

					local insurance = targetchar.get("insurance")
					local insurance_month = insurance.expireMonth
					local insurance_year = insurance.expireYear
					local displayInsurance = "Invalid"
					if insurance_month and insurance_year then
						displayInsurance = insurance_month .. "/" .. insurance_year
					end
					if insurance.planName then
						displayInsurance = "Valid"
					end
					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "***********************************************************************")
					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Name: " .. targetchar.getFullName() .. " | Identifier: " .. targetchar.get("created").ownerIdentifier .. " | Group: " .. user.getGroup() .. " |")
					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Police Rank: " .. targetchar.get("policeRank") .. " | EMS Rank: " .. targetchar.get("emsRank") .. " | Job: " .. targetchar.get("job") .. " | Steam Name: ".. GetPlayerName(args[2]))
					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Cash: " .. comma_value(targetchar.get("money")) .. " | Bank: " .. comma_value(targetchar.get("bank")) .. " |  Ingame Time: " .. FormatSeconds(targetchar.get("ingameTime")) .. " |" )
					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Vehicles: " .. vehiclenames .. " | Insurance: " .. displayInsurance .. " | Driver's License: " .. driving_license .. " |")
					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Weapons: " .. weaponnames .. " | Firearms License: " .. firearms_permit .. " |")
					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Inventory: " .. inventorynames .. " |")
					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Weight: " .. targetchar.getInventoryWeight())
					TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "***********************************************************************")
				end)
			else
				TriggerClientEvent('usa:notify', source, 'Player not found!')
			end
		end
	else
		local user = exports["essentialmode"]:getPlayerFromId(source)
		local ownedVehicles = char.get("vehicles")
		GetMakeModelPlate(ownedVehicles, function(vehs)
			--show player stats
			local vehiclenames = ""
			local userVehicles = vehs
			for i = 1, #userVehicles do
				local vehicle = userVehicles[i]
				vehiclenames = vehiclenames .. userVehicles[i].model
				if i ~= #userVehicles then
					vehiclenames = vehiclenames .. ", "
				end
			end
			local weaponnames = ""
			local userWeapons = char.getWeapons()
			for i = 1, #userWeapons do
				local weapon = userWeapons[i]
				weaponnames = weaponnames .. userWeapons[i].name
				if i ~= #userWeapons then
					weaponnames = weaponnames .. ", "
				end
			end
			local inventorynames = ""
			local userInventory = char.get("inventory").items
			for i = 0, char.get("inventory").MAX_CAPACITY - 1 do
				--local inventory = userInventory[i]
				--local quantity = inventory.quantity
				if userInventory[tostring(i)] then
					inventorynames = inventorynames .. userInventory[tostring(i)].name .. "(" .. userInventory[tostring(i)].quantity .. ")"
					inventorynames = inventorynames .. ", "
				end
			end
			local firearms_permit = "Invalid"
			local driving_license = "Invalid"
			local userLicenses = char.getLicenses()
			for i = 1, #userLicenses do
				local license = userLicenses[i]
				if license.name == "Driver's License"  then
					driving_license = "Valid"
				elseif license.name == "Firearm Permit" then
					firearms_permit = "Valid"
				end
			end

			local insurance = char.get("insurance")
			local insurance_month = insurance.expireMonth
			local insurance_year = insurance.expireYear
			local displayInsurance = "Invalid"
			if insurance_month and insurance_year then
				displayInsurance = insurance_month .. "/" .. insurance_year
			end

			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "***********************************************************************")
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Name: " .. char.getFullName() .. " | Identifer: " .. char.get("created").ownerIdentifier .. " | Group: " .. user.getGroup() .. " |")
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Police Rank: " .. char.get("policeRank") .. " | EMS Rank: " .. char.get("emsRank") .. " |  Job: " .. char.get("job") .. " |" )
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Cash: " .. comma_value(char.get("money")) .. " | Bank: " .. comma_value(char.get("bank")) .. " |  Ingame Time: " .. FormatSeconds(char.get("ingameTime")) .. " |" )
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Vehicles: " .. vehiclenames .. " | Insurance: " .. displayInsurance .. " | Driver's License: " .. driving_license .. " |")
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Weapons: " .. weaponnames .. " | Firearms License: " .. firearms_permit .. " |")
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Inventory: " .. inventorynames .. " |")
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "Weight: " .. char.getInventoryWeight())
			TriggerClientEvent('chatMessage', source, "", {255, 255, 255}, "***********************************************************************")
		end)
	end
end, {
	help = "View character statistics."
})

function comma_value(amount)
	local formatted = amount
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

function FormatSeconds(mins)
	local output = ""
	local days = math.floor(mins / 1440)
	local remainder = mins % 1440
	local hours = math.floor(remainder / 60)
	local mins = remainder % 60
	if days ~= 0 then
		output = days .. " Days"
	end
	if output ~= "" then
		output = output .. ", "
	end
	if hours ~= 0 then
		output = output .. hours .. " Hrs"
	end
	if output ~= "" then
		output = output .. ", "
	end
	output = output .. mins .. " Mins"
	return output
end

function sendMessageToModsAndAdmins(src, msg)
	TriggerEvent("es:getPlayers", function(players)
		if players then
			for id, player in pairs(players) do
				if id and player then
					local playerGroup = player.getGroup()
					if playerGroup == "owner" or playerGroup == "superadmin" or playerGroup == "admin" or playerGroup == "mod" and NotifyStaff(id) and id ~= src then
						TriggerClientEvent("chatMessage", id, "", {}, msg)
					end
				end
			end
		end
	end)
end

function getHoursFromTime(time)
	local reference = time
	local hoursfrom = os.difftime(os.time(), reference) / (60 * 60) -- seconds in a day
	local hours = math.floor(hoursfrom)
	print("hours = " .. hours) -- today it prints "1"
	return hours
end

function GetMakeModelPlate(plates, cb)
	-- query for the information needed from each vehicle --
	local endpoint = "/vehicles/_design/vehicleFilters/_view/getMakeModelPlate"
	local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
	PerformHttpRequest(url, function(err, responseText, headers)
		if responseText then
			local responseVehArray = {}
			--print(responseText)
			local data = json.decode(responseText)
			if data.rows then
				for i = 1, #data.rows do
					local veh = {
						plate = data.rows[i].value[1], -- plate
						make = data.rows[i].value[2], -- make
						model = data.rows[i].value[3] -- model
					}
					table.insert(responseVehArray, veh)
				end
			end
			-- send vehicles to client for displaying --
			--print("# of vehicles loaded for menu: " .. #responseVehArray)
			cb(responseVehArray)
		end
	end, "POST", json.encode({
		keys = plates
		--keys = { "86CSH075" }
	}), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end

-- TESTING COMMAND --
TriggerEvent('es:addGroupCommand', 'test', "owner", function(source, args, char)
	local char = exports["usa-characters"]:GetCharacter(source)
	--TriggerClientEvent("testing:spawnObject", source, "bkr_prop_meth_acetone")
	local lsd = {name = "LSD Vile", price = 6, type = "drug", quantity = 1, legality = "illegal", weight = 5.0, objectModel = "prop_cs_pour_tube"}
	if char.canHoldItem(lsd) then
		char.giveItem(lsd)
	end
end, {
	help = "Test something"
})

function NotifyStaff(source)
	for i = 1, #noNotifications do
		if noNotifications[i] == source then
			return false
		end
	end
	return true
end
