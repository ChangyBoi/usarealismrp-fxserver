-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --
-- NO TOUCHY, IF SOMETHING IS WRONG CONTACT KANERSPS! --

-- SCRATCH THAT^^ TOUCHED BY MINIPUNCH HEHEHEHEEHE

function LoadUser(identifier, source, new)
	-- drop player if Users table contains player object with same identifier (prevent duping)
	for k, v in pairs(Users) do
		if v.getIdentifier() == identifier then
			DropPlayer(source, "SECOND CLIENT!!! WE ARE WATCHING U .................................. BAN BAN BAN BAN BAN BAN BAN BAN BAN BAN BAN BAN BAN BAN BAN BAN BAN BAN BUDDY")
			DropPlayer(v.get("source"), "kicking other client")
			Users[k] = nil
			return
		end
	end
	db.retrieveUser(identifier, function(user)
		Users[source] = CreatePlayer(source, user.permission_level, user.identifier, user.group, user.policeCharacter, user.emsCharacter)
		--print("loaded user " .. GetPlayerName(tonumber(source)) .. "from db...")

		TriggerEvent('es:playerLoaded', source, Users[source])

		TriggerClientEvent('es:setPlayerDecorator', source, 'rank', Users[source]:getPermissions())
		TriggerClientEvent('es:setMoneyIcon', source,settings.defaultSettings.moneyIcon)

		if new then
			TriggerEvent('es:newPlayerLoaded', source, Users[source])
		end

		TriggerEvent("chat:sendToLogFile", source, "joined the server! Timestamp: " .. os.date('%m-%d-%Y %H:%M:%S', os.time()))
	end)
end

function getPlayerFromId(id)
	return Users[id]
end

function stringsplit(inputstr, sep)
	if sep == nil then
			sep = "%s"
		end
		local t={} ; i=1
		for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
			t[i] = str
			i = i + 1
		end
	return t
end

AddEventHandler('es:getPlayers', function(cb)
	cb(Users)
end)

function registerUser(identifier, source)
	db.doesUserExist(identifier, function(exists)
		if exists then
			LoadUser(identifier, source, false)
		else
			db.createUser(identifier, function(r, user)
				LoadUser(identifier, source, true)
			end)
		end
	end)
end

AddEventHandler("es:setPlayerData", function(user, k, v, cb)
	if Users[user] then
		-- passed in group field to save? save it on the user, not the user's character(s)
		Users[user].set(k, v)
		db.updateUser(Users[user].get('identifier'), {group = v}, function(d)
			if d == true then
				cb("Player group data edited", true)
			else
				cb(d, false)
			end
		end)
	else
		cb("User could not be found!", false)
	end
end)

-- todo: update for characters?
AddEventHandler("es:setPlayerDataId", function(user, k, v, cb)
	db.updateUser(user, {[k] = v}, function(d)
		cb("Player data edited.", true)
	end)
end)

AddEventHandler("es:getPlayerFromId", function(user, cb)
	if(Users)then
		if(Users[user])then
			cb(Users[user])
		else
			cb(nil)
		end
	else
		cb(nil)
	end
end)

AddEventHandler("es:getPlayerFromIdentifier", function(identifier, cb)
	db.retrieveUser(identifier, function(user)
		cb(user)
	end)
end)
