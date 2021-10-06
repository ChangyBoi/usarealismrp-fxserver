TriggerEvent("es:exposeDBFunctions", function(api)
    db = api
end)

exports.globals:PerformDBCheck("gcphone", "phone-app-chat", nil)

function currentTimestamp()
  local date = os.date("*t", os.time())
  local mili = 000
  local timestamp = string.format("%02d-%02d-%02d %02d:%02d:%02d.%02d", date.year, date.month, date.day, date.hour, date.min, date.sec, mili)
  return timestamp
end

function TchatGetMessageChannel (channel, cb)
  -- local query = {
  --   ["channel"] = channel
  -- }
  -- db.getDocumentsByRowsLimitAndSort("phone-app-chat", query, 100, {{time = "desc"}}, function(docs)
  --     cb(docs)
  -- end)
  local endpoint = "/phone-app-chat/_design/tchatViews/_view/getMessageByChannel"
  local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
  PerformHttpRequest(url, function(err, responseText, headers)
      if responseText then
        local data = json.decode(responseText)
        local messages = {}
        if data.rows then
            for i = 1, #data.rows do
              if data.rows[i].channel == channel then
                table.insert(messages, data.rows[i])
              end
            end
            for i = 1, #messages do
              messages[i].id = messages[i]._id -- for front end to read correctly, just renaming id field for now
            end
            cb(messages)
        else
            cb({})
        end
      end
  end, "GET", "", { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
  --[[
    MySQL.Async.fetchAll("SELECT * FROM phone_app_chat WHERE channel = @channel ORDER BY time DESC LIMIT 100", { 
        ['@channel'] = channel
    }, cb)
    --]]
end

function TchatAddMessage (channel, message)
  local newMessage = {
    ["channel"] = channel,
    ["message"] = message,
    ["time"] = currentTimestamp()
  }
  db.createDocument("phone-app-chat", newMessage, function(docId)
    TriggerClientEvent('gcPhone:tchat_receive', -1, newMessage)
  end)
  --[[
  local Query = "INSERT INTO phone_app_chat (`channel`, `message`) VALUES(@channel, @message);"
  local Query2 = 'SELECT * from phone_app_chat WHERE `id` = @id;'
  local Parameters = {
    ['@channel'] = channel,
    ['@message'] = message
  }
  MySQL.Async.insert(Query, Parameters, function (id)
    MySQL.Async.fetchAll(Query2, { ['@id'] = id }, function (reponse)
      TriggerClientEvent('gcPhone:tchat_receive', -1, reponse[1])
    end)
  end)
  --]]
end


RegisterServerEvent('gcPhone:tchat_channel')
AddEventHandler('gcPhone:tchat_channel', function(channel)
  local sourcePlayer = tonumber(source)
  TchatGetMessageChannel(channel, function (messages)
    TriggerClientEvent('gcPhone:tchat_channel', sourcePlayer, channel, messages)
  end)
end)

RegisterServerEvent('gcPhone:tchat_addMessage')
AddEventHandler('gcPhone:tchat_addMessage', function(channel, message)
  TchatAddMessage(channel, message)
end)