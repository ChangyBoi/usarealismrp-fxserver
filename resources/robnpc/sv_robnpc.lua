RegisterServerEvent("Mugging:GiveReward")

local items = {
    {name = 'Packaged Weed', type = 'drug', price = 150, legality = 'illegal', quantity = 1, weight = 2.0, objectModel = "bkr_prop_weed_bag_01a"},
    {name = "Packaged Meth", price = 500, type = "drug", quantity = 1, legality = "illegal", weight = 2.0, objectModel = "bkr_prop_meth_smallbag_01a"},
    {name = "Stolen Goods", price = math.random(50, 300), legality = "illegal", quantity = 1, type = "misc", weight = 2.0 },
    { name = "Filet", type = "tradingCard", src = { front = 'usarrp-filet.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Queen", type = "tradingCard", src = { front = 'usarrp-queen.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Emma", type = "tradingCard", src = { front = 'usarrp-emma.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "The Joker", type = "tradingCard", src = { front = 'joker.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Hugh", type = "tradingCard", src = { front = 'Hugh.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Izzy", type = "tradingCard", src = { front = 'Izzy.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Jay", type = "tradingCard", src = { front = 'jAY.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Jim", type = "tradingCard", src = { front = 'Jim.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Johnny", type = "tradingCard", src = { front = 'Johnny.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Jose", type = "tradingCard", src = { front = 'Jose.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Junior", type = "tradingCard", src = { front = 'Junior.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Kacee", type = "tradingCard", src = { front = 'Kacee.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Karen", type = "tradingCard", src = { front = 'Karen.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Knight", type = "tradingCard", src = { front = 'kNIGHT.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Leo", type = "tradingCard", src = { front = 'Leo.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Luke", type = "tradingCard", src = { front = 'Luke.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Morrigan", type = "tradingCard", src = { front = 'Morrigan.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "MPD Ricky", type = "tradingCard", src = { front = 'MPDRicky.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Murphy", type = "tradingCard", src = { front = 'Murphy.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Myst", type = "tradingCard", src = { front = 'Myst.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Nessa", type = "tradingCard", src = { front = 'NessaFinal.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Nessa Smile", type = "tradingCard", src = { front = 'Nessapt2.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Nick", type = "tradingCard", src = { front = 'Nick.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Nate", type = "tradingCard", src = { front = 'NNate.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Owgee", type = "tradingCard", src = { front = 'OWGEE_CARD_2.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Prison", type = "tradingCard", src = { front = 'Prison.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Richard", type = "tradingCard", src = { front = 'Richard.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Ricky", type = "tradingCard", src = { front = 'Ricky.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Sammie", type = "tradingCard", src = { front = 'Sammie.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Sammy", type = "tradingCard", src = { front = 'Sammy.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Sarah", type = "tradingCard", src = { front = 'Sarah.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Simon", type = "tradingCard", src = { front = 'Simon.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Snow", type = "tradingCard", src = { front = 'Snow.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Stacks", type = "tradingCard", src = { front = 'Stacks.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Tommy", type = "tradingCard", src = { front = 'Tommy.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Willy", type = "tradingCard", src = { front = 'Willy.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Zack", type = "tradingCard", src = { front = 'Zack.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Zeke", type = "tradingCard", src = { front = 'Zeke.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "SASP", type = "tradingCard", src = { front = 'sasp3.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Alex & Nessa", type = "tradingCard", src = { front = 'AlexNessa.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Phil 160p", type = "tradingCard", src = { front = 'Phil.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Snake", type = "tradingCard", src = { front = 'Snake.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Sykkuno", type = "tradingCard", src = { front = 'Sy.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Wong", type = "tradingCard", src = { front = 'Wong.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Alex", type = "tradingCard", src = { front = 'Alex.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Amaree", type = "tradingCard", src = { front = 'Amaree.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Carlos", type = "tradingCard", src = { front = 'Carlos.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Chandler", type = "tradingCard", src = { front = 'Chandler.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Cinco", type = "tradingCard", src = { front = 'Cicno.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Edna", type = "tradingCard", src = { front = 'Edna.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Edna & Chang", type = "tradingCard", src = { front = 'EdnaChang.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Gunz", type = "tradingCard", src = { front = 'Gunz.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Hunter", type = "tradingCard", src = { front = 'Hunter.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Jethro", type = "tradingCard", src = { front = 'jethro.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Justin", type = "tradingCard", src = { front = 'Justin.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Larako", type = "tradingCard", src = { front = 'Larako.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Lyssa", type = "tradingCard", src = { front = 'Lyssa.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Maxwell", type = "tradingCard", src = { front = 'Maxwell.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "N8", type = "tradingCard", src = { front = 'N8.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Olivia", type = "tradingCard", src = { front = 'Olivia.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Oscar", type = "tradingCard", src = { front = 'Oscar.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Outlaws", type = "tradingCard", src = { front = 'outlaws.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Pablo", type = "tradingCard", src = { front = 'pablo.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "PB", type = "tradingCard", src = { front = 'PB.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Projects", type = "tradingCard", src = { front = 'Projects.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Pusc", type = "tradingCard", src = { front = 'pusc.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Riley", type = "tradingCard", src = { front = 'Riley.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Ryder", type = "tradingCard", src = { front = 'Ryder.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Sam & Lucy", type = "tradingCard", src = { front = 'SamLucy.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Spider", type = "tradingCard", src = { front = 'Spider.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "SWAT", type = "tradingCard", src = { front = 'swat.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Tony", type = "tradingCard", src = { front = 'Tony.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Tyler", type = "tradingCard", src = { front = 'Tyler.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "William", type = "tradingCard", src = { front = 'William.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "James", type = "tradingCard", src = { front = 'James.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Tony 357", type = "tradingCard", src = { front = 'Tony357.png', back = 'usarrp-trading-card-background.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Narlee", type = "tradingCard", src = { front = 'narlee.png', back = 'backcard.png' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Red Eyes B. Dragon", type = "tradingCard", src = { front = 'red-eyes-black-dragon.jpg', back = 'yugioh-back.jpg' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Dark Magician", type = "tradingCard", src = { front = 'dark-magician.png', back = 'yugioh-back.jpg' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Blue Eyes White Dragon", type = "tradingCard", src = { front = 'blue-eyes-white-dragon.png', back = 'yugioh-back.jpg' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Dark Magician Girl", type = "tradingCard", src = { front = 'dark-magician-girl.png', back = 'yugioh-back.jpg' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Exodia Head", type = "tradingCard", src = { front = 'exodia.png', back = 'yugioh-back.jpg' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Shooting Magestic Star Dragon", type = "tradingCard", src = { front = 'shooting-magestic-star-dragon.png', back = 'yugioh-back.jpg' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
    { name = "Toon Blue Eyes Dragon", type = "tradingCard", src = { front = 'toon-blue-eye-dragon.png', back = 'yugioh-back.jpg' }, price = 300, weight = 1.0, quantity = 1, notStackable = true, objectModel = "p_ld_id_card_002" },
}


AddEventHandler('Mugging:GiveReward', function(securityToken)
    if not exports['salty_tokenizer']:secureServerEvent(GetCurrentResourceName(), source, securityToken) then
		return false
	end
    local char = exports["usa-characters"]:GetCharacter(source)
    local reward = math.random(20,150)
    local PERCENT_CHANCE_ITEM = math.random()
    if PERCENT_CHANCE_ITEM <= 0.25 then
        local randomItem = items[math.random(#items)]
        if not char.canHoldItem(randomItem) then
            TriggerClientEvent("usa:notify", source, "Inventory full")
            return
        end
        char.giveItem(randomItem)
        TriggerClientEvent("usa:notify", source, "You stole a ".. randomItem.name)
    elseif PERCENT_CHANCE_ITEM >= 0.70 then
        TriggerClientEvent("usa:notify", source, "That person had nothing on them!")
    elseif PERCENT_CHANCE_ITEM > 0.25 and PERCENT_CHANCE_ITEM < 0.70 then
        char.giveMoney(reward)
        TriggerClientEvent("usa:notify", source, "You stole $".. reward)
    end

end)