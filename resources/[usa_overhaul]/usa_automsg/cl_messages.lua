local timer = nil

local m = {
    delay = 90,
    prefix = '^5^*[USARRP] ^r^0',
    messages = {
        --"Aspiring to become a police officer? The SASP is hiring! Apply today at https://www.usarrp.net ^*>^r Applications",
        "Check out the new market place for some cool things you can get to support the server! Type ^3/store^0 to check it out!",
        "Aspiring to become a law enforcement officer? The BCSO is hiring! Apply today at https://www.usarrp.net ^*>^r Applications",
        "The San Andreas Department of Corrections is hiring, apply at https://www.usarrp.net ^*>^r Applications",
        "Interested in working a paramedic? Join the Los Santos Fire Department now at https://www.usarrp.net ^*>^r Applications",
        "Get unlimited access to reserved slots and skip ahead of public players in queue when you're whitelisted at https://www.usarrp.net ^*>^r Applications",
        "Have any suggestions, bugs, clips? Become apart of our wonderful community by joining the conversation on Discord! (https://www.discord.me/usarrp)",
        "Don't know where to start? Find our brief guide with commands here: https://www.usarrp.net/server-commands/",
        "Looking to become apart of a our legal initiative? Find how to become a lawyer, or a judge at https://www.usarrp.net ^*>^r Applications",
        "Ever wanted to run a successful business, implemented just for you? Find how at https://www.usarrp.net ^*>^r Forums ^*>^r Department of Justice",
        "You may contribute to running the community by visiting https://www.usarrp.net ^*>^r Donations or finding us on Patreon - you get a shiny tag too!"
    }
}
local timeout = m.delay * 1000 * 60 -- from ms, to sec, to min

Citizen.CreateThread(function()
    while true do
        for i in pairs(m.messages) do
            chat(i)
            Citizen.Wait(timeout)
        end
        Citizen.Wait(0)
    end
end)


TriggerServerEvent('restart:updateStatus')
RegisterNetEvent('restart:notify')
AddEventHandler('restart:notify', function(time)
	if not timer then
		timer = time
		Citizen.CreateThread(function()
			while timer > 0 do
				Citizen.Wait(0)
				DrawTxt(1.2, 1.444, 1.0, 1.0, 0.50, 'Server restarting in '..timer..' minutes, disconnect soon or risk data loss!', 255, 255, 255, 255)
			end
		end)
		Citizen.CreateThread(function()
			while timer > 0 do
				Citizen.Wait(60000)
				timer = timer - 1
			end
		end)
	end
end)

function DrawTxt(x,y ,width,height,scale, text, r,g,b,a)
    SetTextFont(6)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end

function chat(i)
    TriggerEvent('chatMessage', '', {255,255,255}, m.prefix .. m.messages[i])
end