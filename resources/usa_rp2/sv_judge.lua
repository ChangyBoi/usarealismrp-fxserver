licensePrices = {
	["Driver's License"] = 500,
	["Firearm Permit"] = 1000,
	["Bar Certificate"] = 3000,
	["Boat License"] = 750,
	["Aircraft License"] = 1500
}

--------------------
-- EVENT HANDLERS --
--------------------
RegisterServerEvent("judge:duty")
AddEventHandler("judge:duty", function()
  local char = exports["usa-characters"]:GetCharacter(source)
  local job = char.get("job")
  local judge_rank = char.get("judgeRank")
  if not judge_rank then
    TriggerClientEvent("usa:notify", source, "You are not whitelisted for Judge!")
    return
  end
  if job ~= "judge" and judge_rank > 0 then
	local user_char_name = char.getFullName()
   	char.set("job", "judge")
    TriggerClientEvent("usa:notify", source, "You are now in service as a Judge.")
	TriggerClientEvent('chatMessage', -1, "", {0, 0, 0}, "^6^*[COURTHOUSE] ^r^7A Judge is now available for all legal affairs!")
	TriggerEvent("eblips:remove", source)
  else
    char.set("job", "civ")
    TriggerClientEvent("usa:notify", source, "You are now out of service as a Judge.")
  end
end)

-----------------------------
-- LAWYER / JUDGE COMMANDS --
-----------------------------
TriggerEvent('es:addJobCommand', 'removesuspension', {'judge', 'sheriff'}, function(source, args, char)
	local type = string.lower(args[2])
	local target = tonumber(args[3])
	local target_item_name = nil
    -- check SGT + rank for police --
    if char.get("job") == "sheriff" then
        if char.get("policeRank") < 4 then
            TriggerClientEvent("usa:notify", source, "Not high enough rank!")
            return
        end
    end
	if type and GetPlayerName(target) then
		if type == "dl" then
			target_item_name = "Driver's License"
		elseif type == "al" then
			target_item_name = "Aircraft License"
		elseif type == 'bl' then
			target_item_name = "Boat License"
		elseif type == "fp" then
			target_item_name = "Firearm Permit"
		end
		local target_char = exports["usa-characters"]:GetCharacter(target)
		local license = char.getItem(target_item_name)
		if license then
			if license.status == "suspended" then
				char.modifyItem(target_item_name, "status", "valid")
				TriggerClientEvent("usa:notify", target, "Your " .. target_item_name .. " has been ~g~reinstated~s~!")
				TriggerClientEvent("usa:notify", source, "You reinstated a " .. target_item_name .. "!")
			else
				TriggerClientEvent('usa:notify', source, "License not suspended!")
			end
		else
			TriggerClientEvent('usa:notify', source, "License not found on person!")
		end
	end
end, {
	help = "Remove a license suspension.",
	params = {
		{ name = "license type", help = "either BL, AL, DL, or FP" },
		{ name = "id", help = "id of player" }
	}
})


TriggerEvent('es:addJobCommand', 'checklicense', {'judge', 'lawyer', 'sheriff'}, function(source, args, char)
	local type = string.lower(args[2])
	local target = tonumber(args[3])
	local target_item_name = nil
	if type and GetPlayerName(target) then
		if type == "dl" then
			target_item_name = "Driver's License"
		elseif type == "al" then
			target_item_name = "Aircraft License"
		elseif type == 'bl' then
			target_item_name = "Boat License"
		elseif type == 'fp' then
			target_item_name = 'Firearm Permit'
		elseif type == 'bar' then
			target_item_name = 'Bar Certificate'
		end
		local target_player = exports["usa-characters"]:GetCharacter(target)
		local license = target_player.getItem(target_item_name)
	    local user_name = target_player.getFullName()
	    local user_dob = target_player.get('dateOfBirth')
	    if license then
		    TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "^*^7---------------------------------------")
		    TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "^3^*Name: ^r^7" .. user_name)
		    TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "^3^*Date of Birth: ^r^7" .. user_dob)
	        TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "^3^*License: ^r^7" .. license.name)
	        if license.status == 'suspended' then
	        	TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "^3^*Status: ^r^1" .. license.status)
		        TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "^3^*Duration: ^r^7" .. license.suspension_days .. ' day(s)')
		        TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "^3^*Start Date: ^r^7" .. license.suspension_start_date)
		    else
		    	TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "^3^*Status: ^r^2" .. license.status)
			end
			if license.issued_by then
	        	TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "^3^*Issuer: ^r^7" .. license.issued_by)
	        end
	        if license.expire then
	        	TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "^3^*Expires: ^r^7" .. license.expire)
	        end
			TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "^*^7---------------------------------------")
		else
			TriggerClientEvent('chatMessage', source, "", {0, 0, 0}, "^3"..user_name..' ^7does not own a ^3'..target_item_name..'^7.')
		end
	end
end, {
	help = "Check the information of a person's individual license",
	params = {
		{ name = 'license type', help = 'either FP, AL, BL, BAR, or DL'},
		{ name = "id", help = "id of player" }
	}
})

TriggerEvent('es:addJobCommand', 'citynotify', {'judge'}, function(source, args, char)
	table.remove(args,1)
	local msg = table.concat(args, " ")
	TriggerClientEvent('chatMessage', -1, "", {0, 0, 0}, "^3^*[SAN ANDREAS COURT] ^r^7"..msg)
end, {
	help = "Send a state-wide announcement",
	params = {
		{ name = "message", help = "message to be sent" }
	}
})

TriggerEvent('es:addJobCommand', 'expunge', {'sheriff', 'judge'}, function(source, args, char)
	local targetSource = tonumber(args[2])
	local recordid = args[3]
	if char.get("job") == "sheriff" then
        if char.get("policeRank") < 4 then
            TriggerClientEvent("usa:notify", source, "Not high enough rank!")
            return
        end
    end
	if targetSource and GetPlayerName(targetSource) and recordid then
		local target = exports["usa-characters"]:GetCharacter(targetSource)
		local history = target.get("criminalHistory")
		for i = 1, #history do
			local offence = history[i]
			if offence.number == recordid then
				table.remove(history, i)
				TriggerClientEvent('usa:notify', source, 'Offense ~y~'..offence.number..'~s~ has been expunged~s~!')
				target.set("criminalHistory", history)
				return
			end
		end
		TriggerClientEvent('usa:notify', source, 'Offense not found!')
	else
		TriggerClientEvent('usa:notify', source, 'Incorrect usage!')
	end
end, {
	help = "Expunge a record from a person.",
	params = {
		{ name = "id", help = "id of player" },
		{ name = "recordid", help = "record number" }
	}
})

TriggerEvent('es:addJobCommand', 'changesuspension', {'judge'}, function(source, args, char)
	local type = string.lower(args[2])
	local target = tonumber(args[3])
	local days = tonumber(args[4])
	local target_item_name = nil
    -- check SGT + rank for police --
    if char.get("job") == "sheriff" then
        if char.get("policeRank") < 4 then
            TriggerClientEvent("usa:notify", source, "Not high enough rank!")
            return
        end
    end
	if type and GetPlayerName(target) and days then
		if type == "dl" then
			target_item_name = "Driver's License"
		elseif type == "al" then
			target_item_name = "Aircraft License"
		elseif type == 'bl' then
			target_item_name = "Boat License"
		elseif type == "fp" then
			target_item_name = "Firearm Permit"
		end
		local target_player = exports["usa-characters"]:GetCharacter(target)
		local license = target_player.getItem(target_item_name)
		if license and license.status == "suspended" then
			target_player.modifyItem(target_item_name, "suspension_days", days)
			TriggerClientEvent("usa:notify", target, "Your ~y~" .. target_item_name .. " suspension~s~ was modified to end in ~y~" .. days .. " day(s)~s~.")
			TriggerClientEvent("usa:notify", source, "You changed suspension to end in ~y~" .. days .. " day(s)~s~.")
		else
			TriggerClientEvent('usa:notify', source, 'License not found on person, or is not suspended!')
		end
	end
end, {
	help = "Alter a license suspension",
	params = {
		{ name = "license type", help = "either BL, AL, DL, or FP" },
		{ name = "id", help = "id of player" },
		{ name = "days", help = "days to set license suspension to" },
	}
})

TriggerEvent('es:addJobCommand', 'issue', {'judge', 'sheriff'}, function(source, args, char)
	local type = string.lower(args[2])
	local target = tonumber(args[3])
	local target_item_name = nil
	local target_item = nil
  -- check SGT + rank for police --
	  if char.get("job") == "sheriff" then
	      if char.get("policeRank") < 4 then
	          TriggerClientEvent("usa:notify", source, "Not high enough rank!")
	          return
	      end
	  end
	if type and GetPlayerName(target) then
		local target_player = exports["usa-characters"]:GetCharacter(target)
		local timestamp = os.date("*t", os.time())
		if type == "dl" then
			target_item_name = "Driver's License"
			target_item = {
				name = "Driver\'s License",
				number = "F" .. tostring(math.random(1, 2543678)),
				quantity = 1,
				ownerName = target_player.getFullName(),
				issued_by = char.getFullName(),
				ownerDob = char.get("dateOfBirth"),
				expire = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year + 1,
				status = "valid",
				type = "license",
				notDroppable = true,
				weight = 2.0
			}
		elseif type == "fp" then
			target_item_name = "Firearm Permit"
			target_item = {
				name = "Firearm Permit",
				number = "G" .. tostring(math.random(1, 254367)),
				quantity = 1,
				ownerName = target_player.getFullName(),
				issued_by = char.getFullName(),
				ownerDob = char.get("dateOfBirth"),
				expire = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year + 1,
				status = "valid",
				type = "license",
				notDroppable = true,
				weight = 2.0
			}
		elseif type == 'bl' then
			target_item_name = "Boat License"
			target_item = {
				name = 'Boat License',
				number = 'BL' .. tostring(math.random(1, 254367)),
				quantity = 1,
				ownerName = target_player.getFullName(),
				issued_by = char.getFullName(),
				ownerDob = char.get("dateOfBirth"),
				status = "valid",
				type = "license",
				notDroppable = true,
				weight = 2.0
			}
		elseif type == 'al' then
			target_item_name = "Aircraft License"
			target_item = {
				name = 'Aircraft License',
				number = 'PL' .. tostring(math.random(1, 254367)),
				quantity = 1,
				ownerName = target_player.getFullName(),
				issued_by = char.getFullName(),
				ownerDob = char.get("dateOfBirth"),
				expire = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year + 1,
				status = "valid",
				type = "license",
				notDroppable = true,
				weight = 2.0
			}
		elseif type == 'bar' then
			target_item_name = 'Bar Certificate'
			target_item = {
				name = 'Bar Certificate',
				number = 'B' .. tostring(math.random(1, 254367)),
				quantity = 1,
				ownerName = target_player.getFullName(),
				issued_by = char.getFullName(),
				ownerDob = char.get("dateOfBirth"),
				expire = timestamp.month .. "/" .. timestamp.day .. "/" .. timestamp.year + 1,
				status = "valid",
				type = "license",
				notDroppable = true,
				weight = 2.0
			}
		end
		local licenses = target_player.getLicenses()
    	local player_name = target_player.getFullName()
		for i = 1, #licenses do
			if licenses[i].name == target_item_name then
				TriggerClientEvent("usa:notify", source, player_name .. " already has a " .. target_item_name .. "!")
				return
			end
		end
		-- not found at this point, issue it to them --
		local judgeMoney = char.get('money')
		local amountPaid = nil
		for license, price in pairs(licensePrices) do
			if license == target_item_name then
				if judgeMoney - price >= 0  then
					amountPaid = price
					char.removeMoney(price)
				else
					TriggerClientEvent('usa:notify', source, 'You require ~y~$'..price..'.00~s~ to issue this license.')
					return
				end
			end
		end
		target_player.giveItem(target_item)
		if type == "fp" then
			exports["usa_gunshop"]:ShowCCWTerms(target)
		end
		TriggerClientEvent("usa:notify", source, "You issued a ~y~" .. target_item_name .. "~s~ for ~y~$"..amountPaid..'.00~s~!')
		TriggerClientEvent("usa:notify", target, "You were issued a ~y~" .. target_item_name .. "~s~!")
	end
end, {
	help = "Issue a license to a person (COLLECT MONEY FIRST)",
	params = {
		{ name = "license type", help = "either FP, BL, AL, BAR, or DL" },
		{ name = "id", help = "id of player" }
	}
})

TriggerEvent('es:addJobCommand', 'suspend', {'judge', "sheriff"}, function(source, args, char)
	local type = string.lower(args[2])
	local target = tonumber(args[3])
    local days = tonumber(args[4])
	local target_item_name = nil
    -- check SGT + rank for police --
    if char.get("job") == "sheriff" then
        if char.get("policeRank") < 4 then
            TriggerClientEvent("usa:notify", source, "Not high enough rank!")
            return
        end
    end
	if type and GetPlayerName(target) then
		if type == "dl" then
			target_item_name = "Driver's License"
		elseif type == "al" then
			target_item_name = "Aircraft License"
		elseif type == 'bl' then
			target_item_name = "Boat License"
		elseif type == 'bar' then
			target_item_name = "Bar Certificate"
		elseif type == "fp" then
			target_item_name = "Firearm Permit"
		end
		if target_item_name then
			local target_player = exports["usa-characters"]:GetCharacter(target)
			local license =  target_player.getItem(target_item_name)
			if license then
	        	target_player.modifyItem(target_item_name, "status", "suspended")
		      	target_player.modifyItem(target_item_name, "suspension_start", os.time())
		      	target_player.modifyItem(target_item_name, "suspension_days", days)
		      	target_player.modifyItem(target_item_name, "suspension_start_date", os.date('%m-%d-%Y %H:%M:%S', os.time()))
                TriggerClientEvent("usa:notify", source,  "You have suspended ~y~" .. target_item_name .. "~s~ for ~y~" .. days .. " day(s)~s~.")
                TriggerClientEvent("usa:notify", target,  "Your ~y~" .. target_item_name .. "~s~ has been ~y~suspended~s~ for ~y~" .. days .. " day(s)~s~.")
            else
            	TriggerClientEvent('usa:notify', source, 'This license is already suspended!')
            end
	    end
	end
end, {
	help = "Suspend a person's license",
	params = {
		{ name = "license type", help = "either BAR, BL, AL, DL, or FP"},
		{ name = "id", help = "id of player" },
        { name  = "days", help = "# of days to suspend license for"}
	}
})

TriggerEvent('es:addJobCommand', 'revoke', {'judge', 'sheriff'}, function(src, args, char)
	print("inside revoke command handler")
	local type = string.lower(args[2])
	local target = tonumber(args[3])

	if not GetPlayerName(target) then
		TriggerClientEvent("usa:notify", src, "Invalid ID provided")
		return
	end

    -- check SGT + rank for police --
    if char.get("job") == "sheriff" then
        if char.get("policeRank") < 4 then
            TriggerClientEvent("usa:notify", src, "Not high enough rank!")
            return
        end
    end

	local target_item_name = nil
	if type then
		if type == "dl" then
			target_item_name = "Driver's License"
		elseif type == "al" then
			target_item_name = "Aircraft License"
		elseif type == 'bl' then
			target_item_name = "Boat License"
		elseif type == 'fp' then
			target_item_name = 'Firearm Permit'
		elseif type == 'bar' then
			target_item_name = 'Bar Certificate'
		end
		local target_player = exports["usa-characters"]:GetCharacter(target)
		if target_player.hasItem(target_item_name) then
			target_player.removeItem(target_item_name, 1)
			TriggerClientEvent("usa:notify", src,  "You have revoked ~y~" .. target_item_name .. "~s~.")
			TriggerClientEvent("usa:notify", target,  "Your ~y~" .. target_item_name .. "~s~ has been revoked.")
        else
			TriggerClientEvent("usa:notify", src, "No "..target_item_name.." found~s~!")
        end
	end
end, {
	help = "Revoke a person's license",
	params = {
		{ name = "license type", help = "either FP, BL, AL, BAR or DL"},
		{ name = "id", help = "id of player" }
	}
})
