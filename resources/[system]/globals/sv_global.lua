function sendLocalActionMessageChat(message, location, range)
	-- set default range
	if not range then
		range = 30
	end

	--TriggerClientEvent("globals:startActionMessage", -1, message, range, src)

	TriggerClientEvent(
		'chatMessageLocation',
		-1,
		"",
		{255, 240, 240},
		message,
		location,
		range
	)
end

function sendLocalActionMessage(_source, text, maxDist, time)
	if not maxDist then maxDist = 10.0 end
	if not time then time = 3000 end
	TriggerClientEvent("globals:startActionMessage", -1, _source, text, maxDist, time)
end

function notifyPlayersWithJobs(target_jobs, msg, specialRequest)
	exports["usa-characters"]:GetCharacters(function(players)
		if not players then
			return
		end
		for id, player in pairs(players) do
			if id and player then
				local job = player.get("job")
				for i = 1, #target_jobs do
					if job == target_jobs[i] then
						if specialRequest == "onlyDeputiesNoCOs" and job == "corrections" then
							TriggerEvent("es:exposeDBFunctions", function(db)
								local ident = GetPlayerIdentifiers(player.get("source"))[1]
								db.getDocumentByRow("correctionaldepartment", "identifier", ident, function(doc)
									if doc then
										if doc.rank >= 3 then 
											TriggerClientEvent("chatMessage", id, "", {}, "^0" .. msg)
										end
									end
								end)
							end)
						else 
							TriggerClientEvent("chatMessage", id, "", {}, "^0" .. msg)
						end
					end
				end
			end
		end
	end)
end

function notifyPlayersWithJob(target_job, msg)
 	exports["usa-characters"]:GetCharacters(function(players)
		if not players then
			return
		end
		for id, player in pairs(players) do
			if id and player then
				local job = player.get("job")
				if job == target_job then
					TriggerClientEvent("chatMessage", id, "", {}, "^0" .. msg)
				end
			end
		end
	end)
end

function setJob(src, job)
	exports["usa-characters"]:SetCharacterField(src, "job", job)
	TriggerClientEvent("usa:notify", src, "Job set to: " .. job)
end

TriggerEvent('es:addGroupCommand', 'setjob', 'owner', function(source, args, char)
	setJob(source, args[2])
end, {
	help = "DEBUG: SET YOUR JOB"
})


exports("PerformDBCheck", function(scriptName, db, doneFunc)
	PerformHttpRequest("http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. "/" .. db .. "/_compact", function(err, rText, headers)
	end, "POST", "", {["Content-Type"] = "application/json", Authorization = "Basic " .. exports["essentialmode"]:getAuth()})
	
	PerformHttpRequest("http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. "/" .. db, function(err, rText, headers)
		if err == 0 then
			print("-------------------------------------------------------------")
			print("--- No errors detected, " .. scriptName .. " is setup properely. ---")
			print("-------------------------------------------------------------")
		elseif err == 412 then
			print("-------------------------------------------------------------")
			print("--- No errors detected, " .. scriptName .. " is setup properely. ---")
			print("-------------------------------------------------------------")
		elseif err == 401 then
			print("------------------------------------------------------------------------------------------------")
			print("--- Error detected in authentication, please take a look at config.lua inside essentialmode. ---")
			print("------------------------------------------------------------------------------------------------")
		elseif err == 201 then
			print("-------------------------------------------------------------")
			print("--- No errors detected, " .. scriptName .. " is setup properely. ---")
			print("-------------------------------------------------------------")
		else
			print("------------------------------------------------------------------------------------------------")
			print("--- Unknown error detected ( " .. err .. " ): " .. (rText or "could not get rText"))
			print("------------------------------------------------------------------------------------------------")
		end
		-- Function to execute when finished checking DB --
		if doneFunc then
			doneFunc()
		end
	end, "PUT", "", {Authorization = "Basic " .. exports["essentialmode"]:getAuth()})
end)

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

RegisterServerEvent("globals:send3DText")
AddEventHandler("globals:send3DText", function(msg)
	sendLocalActionMessage(source, msg)
end)

function GetHoursFromTime(time)
	return math.floor(os.difftime(os.time(), time) / (60 * 60))
end

function GetSecondsFromTime(time)
	return math.floor(os.difftime(os.time(), time))
end

function SendDiscordLog(webhookUrl, msg)
    PerformHttpRequest(webhookUrl, function(err, text, headers)
    end, "POST", json.encode({
		content = msg
		--[[
        embeds = {
            {
                description = (msg or "No Message"),
                color = (color or 524288),
                author = {
                    name = (title or "No Title")
                }
            }
		}
		--]]
    }), { ["Content-Type"] = 'application/json' })
end

function replaceChar(pos, str, r)
    return ("%s%s%s"):format(str:sub(1,pos-1), r, str:sub(pos+1))
end

function getCoordDistance(coords1, coords2)
	xdistance =  math.abs(coords1.x - coords2.x)
	ydistance = math.abs(coords1.y - coords2.y)
	zdistance = math.abs(coords1.z - coords2.z)
	return nroot(3, (xdistance ^ 3 + ydistance ^ 3 + zdistance ^ 3))
end

function nroot(root, num)
	return num^(1/root)
end

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end

function getNumCops(cb)
	Citizen.CreateThread(function()
		local doneCounting = false
		local count = exports["usa-characters"]:GetNumCharactersWithJob("sheriff")
		local bcso = exports["usa-characters"]:GetPlayerIdsWithJob("corrections")
		if #bcso > 0 then
			for i = 1, #bcso do
				local id = bcso[i]
				exports.usa_prison:getBCSORank(id, function(rank)
					if rank >= 3 then
						count = count + 1
					end
					if i == #bcso then
						doneCounting = true
					end
				end)
			end
		else
			doneCounting = true
		end
		while not doneCounting do
			Wait(10)
		end
		cb(count)
	end)
end

function getCopIds(cb)
	Citizen.CreateThread(function()
		local done = false
		local ids = exports["usa-characters"]:GetPlayerIdsWithJob("sheriff")
		local bcso = exports["usa-characters"]:GetPlayerIdsWithJob("corrections")
		if #bcso > 0 then
			for i = 1, #bcso do
				local id = bcso[i]
				exports.usa_prison:getBCSORank(id, function(rank)
					if rank >= 3 then
						table.insert(ids, id)
					end
					if i == #bcso then
						done = true
					end
				end)
			end
		else
			done = true
		end
		while not done do
			Wait(10)
		end
		cb(ids)
	end)
end

function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

-- to mimic MySql's current_timestamp()
function currentTimestamp()
    local date = os.date("*t", os.time())
    local timestamp = string.format("%02d-%02d-%02d %02d-%02d-%02d", date.year, date.month, date.day, date.hour, date.min, date.sec)
    return timestamp
end