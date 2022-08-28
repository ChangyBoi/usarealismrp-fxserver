const ReplaceStr = '_%_';

export const TSL = {
    list: {
        "reveal_cards": "Revealing player cards.",
        "deal_flop": "Dealing flop cards.",
        "deal_turn": "Dealing turn card.",
        "deal_river": "Dealing river card.",
        "everyone_throwed": "The game ended, everyone throwed in.",
        "new_game_begins": "New game starting.",
        "not_valid_bet": "Not valid bet amount",
        "error_not_sitting": "You are not sitting at the chair.Some error happened ?",
        "not_enough_chips": "You do not have enough chips.",
        "error_some": "Some error happened during the calling, try to bet.",
        "can_not_join_yet": "You can not join to the game yet, wait for the current party to end.",
        "not_enough_chips_toplay": "You do not have enough chips to play!",
        "smallblind_not_enough_chips": "Small blind player did not have enough chips to bet in the round, the game did not start.",
        "bigblind_not_enough_chips": "Big blind player did not have enough chips to bet in the round, the game did not start.",
    
        // STAT NAMES
        "stat_wonchips": "Won chips",
        "stat_played": "Played games",
        "stat_wongames": "Won games",
        "stat_betchips": "Chips betted",
        "stat_winrate": "Winrate",
    
        // FORMATTED
        "dealer_is": `Dealer is: ${ReplaceStr}.`,
        "bet_smallblind": `${ReplaceStr} put in the small blind ${ReplaceStr} chips.`,
        "bet_bigblind": `${ReplaceStr} put in the big blind ${ReplaceStr} chips.`,
        "bet_raised": `${ReplaceStr} raised the bet with ${ReplaceStr} chips.`,
        "simple_bet": `${ReplaceStr} bet ${ReplaceStr} chips.`,
        "throwed": `${ReplaceStr} throwed his cards.`,
        "player_joined": `${ReplaceStr} joined to the party.`,
        "player_leaved": `${ReplaceStr} leaved the party.`,
        "minimum_bet_is": `Minimum bet is ${ReplaceStr} chips.`,
        "raise_should_be": `Raise should be double of the highest bet ${ReplaceStr} chips.`,
        "winner_is": `${ReplaceStr} won ${ReplaceStr} chips.`
    },
    format(msg: string, args: (string | number)[]) {
        try {
            let message = msg;
            for (let i = 0; i < args.length; i++) {
                message = message.replace(ReplaceStr, args[i].toString());
            }
            return message;
        } catch {
            return 'UNKNOWN_TRANSLATION';
        }
    }
}