import * as AquiverShared from "@aquiversdk/shared";
import { TSL } from '../shared/locales';
import { CardManager } from './cards';
import { get_winners } from './deck_checker';
import { Methods } from './methods';
import { PokerPlayer } from './player';

enum GAMESTAGES {
    'GAME_NOT_STARTED' = 1,
    'ROUNDS' = 2,
    'SHOWING_CARDS' = 3,
}
enum TIMES {
    'GAME_NOT_STARTED' = 5,
    'ROUNDS' = 15,
    'SHOWING_CARDS' = 15,
}
export const CHAIRS = [
    { offset: new AquiverShared.Vec3(-0.75, 1.43, -0.45), heading: 310.0 },
    { offset: new AquiverShared.Vec3(0.75, 1.43, -0.45), heading: 225.0 },
    { offset: new AquiverShared.Vec3(1.1, 0.0, -0.45), heading: 180.0 },
    { offset: new AquiverShared.Vec3(0.75, -1.43, -0.45), heading: 130.0 },
    { offset: new AquiverShared.Vec3(-0.75, -1.43, -0.45), heading: 45.0 },
];

type UpdaterKeys = 'mainpot' | 'dealercards' | 'timer' | 'gamestage' | 'logs' | 'all' | 'players' | 'currentplayer';

class PokerTable {
    LogsProxy: string[] = new Proxy([], {
        get: (target, key) => {
            let val = target[key];
            if (typeof val === 'function') {
                if (['push', 'unshift'].includes(key as string)) {
                    return (...args: string[]) => {
                        /** Apply the push here */
                        val.apply(target, args);

                        const pushedData = args[0];

                        if (this.LogsProxy.length > 200) {
                            this.LogsProxy.pop();
                        }

                        this.playersOpened.forEach((playerData) => {
                            playerData.triggerClient('add-log-entry', pushedData);
                        });
                    };
                }
            }
            return typeof val === 'function' ? val.bind(target) : val;
        },
    });

    DealerCardsProxy: string[] = new Proxy([], {
        get: (target, key) => {
            let val = target[key];
            if (typeof val === 'function') {
                if (['push', 'unshift'].includes(key as string)) {
                    return (...args: string[]) => {
                        /** Apply the push here */
                        val.apply(target, args);

                        const pushedData = args[0];

                        this.update('dealercards');
                    };
                }
            }
            return typeof val === 'function' ? val.bind(target) : val;
        },
    });

    /** Store the cards which can not be picked up again. */
    cardIndexesExist = new Set<number>();
    chairPlayers: PokerPlayer[] = [];
    playersOpened: PokerPlayer[] = [];
    currentPlayer: number = null;

    private _gamestage: GAMESTAGES = GAMESTAGES.GAME_NOT_STARTED;
    private _time: number | TIMES = TIMES.GAME_NOT_STARTED;

    constructor(private _data: TableConfigInterface) {
        console.info(`Poker table created ID: ${this.id}`);

        /** For testing purposes. */
        // if (this.id == 1) {
        //     /** PLAYER A */
        //     let pl_01 = new PokerPlayer(1, { uniqueId: '', img: '', stat_betchips: 0, stat_played: 0, stat_wonchips: 0, stat_wongames: 0 });
        //     pl_01.allbet = 8000;
        //     pl_01.allined = true;
        //     pl_01.roundbet = 200;
        //     pl_01.cards = ['c1', 'd4'];

        //     /** PLAYER B */
        //     let pl_02 = new PokerPlayer(2, { uniqueId: '', img: '', stat_betchips: 0, stat_played: 0, stat_wonchips: 0, stat_wongames: 0 });
        //     pl_02.allbet = 120000;
        //     pl_02.allined = true;
        //     pl_02.roundbet = 200;
        //     pl_02.cards = ['c10', 'd10'];

        //     this.checkingWinners([], [pl_01, pl_02], true);
        // }
    }
    get time() {
        return this._time;
    }
    get id() {
        return this._data.id;
    }
    get pos() {
        return this._data.pos;
    }
    get heading() {
        return this._data.heading;
    }
    get blind() {
        return this._data.blind;
    }
    get gamestage() {
        return this._gamestage;
    }
    set time(t: number | TIMES) {
        this._time = t;
        this.update('timer');
    }
    set gamestage(stage: GAMESTAGES) {
        this._gamestage = stage;
        this.update('gamestage');
    }
    getFreeChairId() {
        for (let i = 0; i < CHAIRS.length; i++) {
            const exist = this.chairPlayers.findIndex((a) => a.chairId == i);
            if (exist === -1) return i;
        }
    }
    isValidBet(amount: number) {
        amount = Math.floor(amount);
        if (isNaN(amount)) return false;
        return true;
    }
    isPlayerCurrentPlayer(Player: PokerPlayer) {
        try {
            return this.getCurrentPlayerData().source == Player.source;
        } catch {
            return false;
        }
    }
    canCall(Player: PokerPlayer) {
        /** Falses */
        if (this.gamestage != GAMESTAGES.ROUNDS) return false;

        const callAmount = this.calculateCall(Player);
        if (callAmount > Player.chips) return false;

        if (Player.allined) return false;
        if (Player.throwed) return false;
        if (Player.passed) return false;

        return true;
    }
    canAllIn(Player: PokerPlayer) {
        /** Falses */
        if (this.gamestage != GAMESTAGES.ROUNDS) return false;

        if (Player.allined) return false;
        if (Player.throwed) return false;
        if (Player.passed) return false;

        return true;
    }
    canBet(Player: PokerPlayer) {
        /** Falses */
        if (this.gamestage != GAMESTAGES.ROUNDS) return false;

        const callAmount = this.calculateCall(Player);
        if (callAmount > Player.chips) return false;

        if (Player.allined) return false;
        if (Player.throwed) return false;
        if (Player.passed) return false;

        return true;
    }
    canThrow(Player: PokerPlayer) {
        /** Falses */
        if (this.gamestage != GAMESTAGES.ROUNDS) return false;
        if (Player.allined) return false;
        if (Player.throwed) return false;
        if (Player.passed) return false;

        return true;
    }
    canPass(Player: PokerPlayer) {
        /** Falses */
        if (this.gamestage != GAMESTAGES.ROUNDS) return false;
        if (Player.allined) return false;
        if (Player.throwed) return false;
        if (Player.passed) return false;

        /** Trues */
        if (!Player.wasInRound && !Player.passed && this.getHighestBetInRound() == 0) return true;
        if (this.getHighestBetInRound() == Player.roundbet) return true;

        return false;
    }
    passPoker(Player: PokerPlayer) {
        if (this.gamestage != GAMESTAGES.ROUNDS) return;
        if (!Player.exist()) return;

        if (!this.isPlayerCurrentPlayer(Player)) return;

        if (this.canPass(Player)) {
            this.time = TIMES.ROUNDS;
            Player.wasInRound = true;
            Player.passed = true;
            this.getNextPlayer();
        }
    }
    /**
     * leaved is a force leave, when the player is not the action holder, but leaves the table.
     * we needed this var, to the functions works without checking the actioner.
     */
    throwPoker(Player: PokerPlayer, leaved?: boolean) {
        if (this.gamestage != GAMESTAGES.ROUNDS) return;

        if (!this.isPlayerCurrentPlayer(Player) && !leaved) return;

        Player.throwed = true;
        this.createLog(TSL.format(TSL.list.throwed, [Player.name]));
        this.TriggerClientTablePlayers('cef_playsound', 'shuffle_cards_2.wav');

        if (this.count_playersIngame() <= 1) {
            this.createLog(TSL.list.everyone_throwed);
            this.checkingWinners();
        } else {
            this.time = TIMES.ROUNDS;
            this.getNextPlayer();
        }
    }
    raffleDealerPosition() {
        if (this.count_playersTable() < 1) return;

        const randomPlayerIndex = Math.floor(Math.random() * this.chairPlayers.length);
        this.chairPlayers[randomPlayerIndex].dealer = true;
        this.setCurrentPlayer(randomPlayerIndex);
        this.createLog(TSL.format(TSL.list.dealer_is, [this.getCurrentPlayerData().name]));

        /** Put in the blinds then set the next player. */
        this.betAutomaticBlinds();
    }
    betPoker(Player: PokerPlayer, amount: number) {
        if (this.gamestage != GAMESTAGES['ROUNDS']) return;
        if (!this.isPlayerCurrentPlayer(Player)) return;
        if (!Player.exist()) return;
        if (amount < 1) this.passPoker(Player);
        if (!this.isValidBet(amount)) return Player.Notification(TSL.list.not_valid_bet);

        if (Player.chips < amount) return Player.Notification(TSL.list.not_enough_chips);

        if (amount >= Player.chips) {
            /** This is all-in. */
            Player.allined = true;
            Player.roundbet += amount;
            Player.allbet += amount;
            this.createLog(`${Player.name} all-in. (${amount})`);

            this.chairPlayers.forEach((playerData) => {
                if (playerData.source == Player.source) return;

                if (playerData.roundbet < amount) {
                    playerData.wasInRound = false;
                }
            });
        } else {
            const minimumBet = this.calculateCall(Player);
            if (amount < minimumBet && minimumBet > 0) return Player.Notification(TSL.format(TSL.list.minimum_bet_is, [minimumBet]));

            const neededToRaise = this.calculateNeededRaise();
            if (Player.roundbet + amount > this.getHighestBetInRound() || (amount >= neededToRaise && this.getHighestBetInRound() > 0)) {
                /** Raise */
                if (amount > minimumBet && amount < neededToRaise) return Player.Notification(TSL.format(TSL.list.raise_should_be, [neededToRaise]));
                this.createLog(TSL.format(TSL.list.bet_raised, [Player.name, amount]));

                this.chairPlayers.forEach((playerData) => {
                    /** Reset the players who was in round, because the bet is higher */
                    if (playerData.source != Player.source) {
                        playerData.wasInRound = false;
                    }
                });
            } else {
                /** Call */
                this.createLog(TSL.format(TSL.list.simple_bet, [Player.name, amount]));
            }

            Player.roundbet += amount;
            Player.allbet += amount;
        }

        this.playBetSFX();
        this.chairPlayers.forEach((playerData) => {
            /** Reset the players who passed. */
            if (playerData.passed) {
                playerData.wasInRound = false;
                playerData.passed = false;
            }
        });

        Player.wasInRound = true;
        Player.stat_betchips += amount;
        Player.chips -= amount;
        this.time = TIMES.ROUNDS;
        this.getNextPlayer();
    }
    callPoker(Player: PokerPlayer) {
        if (this.gamestage != GAMESTAGES.ROUNDS) return;
        if (!Player.exist()) return;
        if (!this.isPlayerCurrentPlayer(Player)) return;

        const call = this.calculateCall(Player);
        if (call == null) return Player.Notification(TSL.list.error_some);

        if (Player.chips < call) return Player.Notification(TSL.list.not_enough_chips);
        if (call < call && call > 0) return Player.Notification(TSL.format(TSL.list.minimum_bet_is, [call]));
        this.betPoker(Player, call);
    }
    allInPoker(Player: PokerPlayer) {
        if (this.gamestage != GAMESTAGES.ROUNDS) return;
        if (!Player.exist()) return;
        this.betPoker(Player, Player.chips);
    }
    getNextPlayer() {
        this.currentPlayer++;

        if (this.currentPlayer >= this.count_playersTable()) {
            this.currentPlayer = 0;
        }

        while (
            this.chairPlayers[this.currentPlayer] &&
            (this.chairPlayers[this.currentPlayer].wasInRound || this.chairPlayers[this.currentPlayer].throwed || this.chairPlayers[this.currentPlayer].allined)
        ) {
            this.currentPlayer++;
        }

        if (this.currentPlayer >= this.count_playersTable()) {
            this.currentPlayer = 0;
        }

        this.setCurrentPlayer(this.currentPlayer);

        /** If no more players in the round. */
        if (this.chairPlayers.filter((a) => !a.wasInRound && !a.throwed && !a.allined).length < 1) {
            const dealed = this.dealDealerCards();
            if (dealed) {
                /** Set current player next to the dealer. */
                this.currentPlayer = this.chairPlayers.findIndex((a) => a.dealer);
                this.getNextPlayer();
            } else {
                this.checkingWinners();
            }
        } else {
            this.update('players');
        }
    }
    getCurrentPlayerData() {
        return this.chairPlayers[this.currentPlayer];
    }
    setCurrentPlayer(id: number) {
        this.currentPlayer = id;
        this.update('currentplayer');
        if (id != null) {
            let ActionPlayer = this.getCurrentPlayerData();

            ActionPlayer.triggerClient('cef_playsound', 'player_alert.wav');

            if (this._gamestage == GAMESTAGES.ROUNDS) {
                const c = this.calculateCall(ActionPlayer);

                ActionPlayer.triggerClient('setCefVariable', 'callAmount', c);
            }
        }
    }
    dealPlayerCards() {
        this.chairPlayers.forEach((playerData) => {
            while (playerData.cards.length < 2) {
                const randomCard = CardManager.getRandomCard(this.cardIndexesExist);
                playerData.cards.push(randomCard);
            }
        });
        this.update('players');
    }
    dealDealerCards() {
        if (this.count_playersIngame() <= 1) {
            return false;
        }

        if (this.DealerCardsProxy.length == 0) {
            this.createLog(TSL.list.deal_flop);
            while (this.DealerCardsProxy.length < 3) {
                const randomCard = CardManager.getRandomCard(this.cardIndexesExist);
                this.DealerCardsProxy.push(randomCard);
            }

            this.resetRoundBets();
            this.TriggerClientTablePlayers('cef_playsound', 'shuffle_cards.wav');
            return true;
        } else if (this.DealerCardsProxy.length == 3) {
            this.createLog(TSL.list.deal_turn);
            const randomCard = CardManager.getRandomCard(this.cardIndexesExist);
            this.DealerCardsProxy.push(randomCard);
            this.resetRoundBets();
            this.TriggerClientTablePlayers('cef_playsound', 'shuffle_cards_2.wav');
            return true;
        } else if (this.DealerCardsProxy.length == 4) {
            this.createLog(TSL.list.deal_river);
            const randomCard = CardManager.getRandomCard(this.cardIndexesExist);
            this.DealerCardsProxy.push(randomCard);
            this.resetRoundBets();
            this.TriggerClientTablePlayers('cef_playsound', 'shuffle_cards_3.wav');
            return true;
        }

        return false;
    }
    betAutomaticBlinds() {
        this.getNextPlayer(); // so not the dealer who got picked
        let smallBlindPlayerData = this.chairPlayers[this.currentPlayer];
        this.getNextPlayer();
        let bigBlindPlayerData = this.chairPlayers[this.currentPlayer];

        if (smallBlindPlayerData && bigBlindPlayerData) {
            const smallblind = this.blind;
            const bigblind = this.blind * 2;

            if (!smallBlindPlayerData.exist() || smallBlindPlayerData.chips < smallblind) {
                this.createLog(TSL.list.smallblind_not_enough_chips);
                /** Standup the player and restart the game. */
                smallBlindPlayerData.tableId = null;
                this.resetGame();
                return;
            }
            if (!bigBlindPlayerData.exist() || bigBlindPlayerData.chips < bigblind) {
                this.createLog(TSL.list.bigblind_not_enough_chips);
                /** Standup the player and restart the game. */
                bigBlindPlayerData.tableId = null;
                this.resetGame();
                return;
            }

            this.chairPlayers.forEach((playerData) => {
                playerData.stat_played++;
            });

            smallBlindPlayerData.smallblind = true;
            smallBlindPlayerData.roundbet += smallblind;
            smallBlindPlayerData.allbet += smallblind;
            smallBlindPlayerData.stat_betchips += smallblind;
            smallBlindPlayerData.chips -= smallblind;

            bigBlindPlayerData.bigblind = true;
            bigBlindPlayerData.roundbet += bigblind;
            bigBlindPlayerData.allbet += bigblind;
            bigBlindPlayerData.stat_betchips += bigblind;
            bigBlindPlayerData.chips -= bigblind;

            this.createLog(TSL.format(TSL.list.bet_smallblind, [smallBlindPlayerData.name, smallblind]));
            this.createLog(TSL.format(TSL.list.bet_bigblind, [bigBlindPlayerData.name, bigblind]));

            /** Deal player cards */
            this.gamestage = GAMESTAGES.ROUNDS;
            this.time = TIMES.ROUNDS;
            this.getNextPlayer();
            this.dealPlayerCards();
            this.playBetSFX();
        }
    }
    resetRoundBets() {
        this.update('mainpot');

        this.chairPlayers.forEach((playerData) => {
            playerData.roundbet = 0;
            playerData.wasInRound = false;
            playerData.passed = false;
        });
    }
    calculateCall(Player: PokerPlayer) {
        const highestBet = this.getHighestBetInRound();
        return Math.floor(highestBet - Player.roundbet);
    }
    getPlayerChairData(Player: PokerPlayer) {
        return this.chairPlayers.find((a) => a.source == Player.source);
    }
    calculateNeededRaise() {
        return this.getHighestBetInRound() * 2;
    }
    getHighestBetInRound() {
        let bets = this.chairPlayers.map((a) => {
            return a.roundbet;
        });
        bets.sort((b, c) => c - b);
        return bets[0];
    }
    count_playersIngame() {
        return this.chairPlayers.filter((a) => !a.throwed && !a.allined).length;
    }
    count_playersTable() {
        return this.chairPlayers.length;
    }
    joinPlayer(Player: PokerPlayer) {
        if (this.gamestage !== GAMESTAGES.GAME_NOT_STARTED) return Player.Notification('can_not_join_yet');

        const freeChairId = this.getFreeChairId();
        if (freeChairId !== null && CHAIRS[freeChairId]) {
            Player.chairId = freeChairId;
            this.chairPlayers.push(Player);

            const { offset, heading } = CHAIRS[freeChairId];
            Player.triggerClient('AquiverTexasPoker:sitDownClient', this.id, offset, heading);
            this.update('players');
            this.createLog(TSL.format(TSL.list.player_joined, [Player.name]));
        }
    }
    TriggerClientTablePlayers(eventName: string, ...args: any[]) {
        this.playersOpened.forEach((playerData) => {
            playerData.triggerClient(eventName, ...args);
        });
    }
    playBetSFX() {
        const sfxes = ['player_bet.wav', 'player_bet_2.wav', 'player_bet_3.wav', 'player_bet_4.wav', 'player_bet_5.wav', 'player_bet_6.wav'];
        const randomsfx = sfxes[Math.floor(Math.random() * sfxes.length)];
        this.TriggerClientTablePlayers('cef_playsound', randomsfx);
    }
    tickTime() {
        if (this.gamestage == GAMESTAGES.GAME_NOT_STARTED) {
            if (this.count_playersTable() >= 2) {
                const playerCanPlay = this.chairPlayers.filter((a) => a.chips > this.blind * 2).length;
                if (playerCanPlay >= 2) {
                    this.time--;

                    if (this.time < 1) {
                        this.raffleDealerPosition();
                    }
                } else {
                    this.chairPlayers.forEach((playerData) => {
                        if (playerData.chips < this.blind * 2) {
                            playerData.tableId = null;
                            playerData.Notification(TSL.list.not_enough_chips_toplay);
                        }
                    });
                }
            }
        } else if (this.gamestage == GAMESTAGES.ROUNDS) {
            this.time--;

            if (this.time < 1) {
                const InactivePokerPlayer = this.getCurrentPlayerData();
                if (!InactivePokerPlayer) return this.resetGame();

                this.throwPoker(InactivePokerPlayer);
            }
        } else if (this.gamestage == GAMESTAGES.SHOWING_CARDS) {
            this.time--;

            if (this.time < 1) {
                this.resetGame();
            }
        }
    }
    update(type: UpdaterKeys, Player?: PokerPlayer) {
        const e_updater = 'setCefVariable';

        switch (type) {
            case 'currentplayer': {
                if (Player) Player.triggerClient(e_updater, 'currentplayer', this.currentPlayer);
                else this.TriggerClientTablePlayers(e_updater, 'currentplayer', this.currentPlayer);

                /** Pass button */
                this.chairPlayers.forEach((playerData) => {
                    /** Disable all buttons if he is not the current player */
                    playerData.triggerClient(e_updater, 'disableallbuttons', !this.isPlayerCurrentPlayer(playerData));

                    playerData.triggerClient(e_updater, 'canpass', this.canPass(playerData));
                    playerData.triggerClient(e_updater, 'cancall', this.canCall(playerData));
                    playerData.triggerClient(e_updater, 'canthrow', this.canThrow(playerData));
                    playerData.triggerClient(e_updater, 'canallin', this.canAllIn(playerData));
                    playerData.triggerClient(e_updater, 'canbet', this.canBet(playerData));
                });
                break;
            }
            case 'players': {
                /** Do not send the cards. */
                if (this.gamestage != GAMESTAGES.SHOWING_CARDS) {
                    let format: PokerPlayer[] = JSON.parse(JSON.stringify(this.chairPlayers.map((a) => a.toNUIObject())));
                    format.forEach((a) => (a.cards = []));

                    if (Player) Player.triggerClient(e_updater, 'players', format);
                    else {
                        this.TriggerClientTablePlayers(e_updater, 'players', format);
                    }

                    this.chairPlayers.forEach((playerData) => {
                        playerData.triggerClient('update_my_cards', playerData.toNUIObject());
                    });
                } else {
                    const format = this.chairPlayers.map((a) => a.toNUIObject());

                    if (Player) Player.triggerClient(e_updater, 'players', format);
                    else this.TriggerClientTablePlayers(e_updater, 'players', format);
                }

                break;
            }
            case 'mainpot': {
                const c = this.getMainPot();

                if (Player) Player.triggerClient(e_updater, 'mainpot', c);
                else this.TriggerClientTablePlayers(e_updater, 'mainpot', c);
                break;
            }
            case 'dealercards': {
                if (Player) Player.triggerClient(e_updater, 'dealercards', this.DealerCardsProxy);
                else this.TriggerClientTablePlayers(e_updater, 'dealercards', this.DealerCardsProxy);
                break;
            }
            case 'timer': {
                if (Player) Player.triggerClient(e_updater, 'timer', this.time);
                else this.TriggerClientTablePlayers(e_updater, 'timer', this.time);
                break;
            }
            case 'gamestage': {
                if (Player) Player.triggerClient(e_updater, 'gamestage', this.gamestage);
                else this.TriggerClientTablePlayers(e_updater, 'gamestage', this.gamestage);
                break;
            }
            case 'logs': {
                if (Player) Player.triggerClient(e_updater, 'logs', this.LogsProxy);
                else this.TriggerClientTablePlayers(e_updater, 'logs', this.LogsProxy);
                break;
            }
            case 'all': {
                const all: UpdaterKeys[] = ['currentplayer', 'dealercards', 'gamestage', 'logs', 'mainpot', 'players', 'timer'];
                all.forEach((t) => {
                    Player ? this.update(t, Player) : this.update(t);
                });
                break;
            }
            default: {
                console.error(`Poker update failed. type not exist: ${type}`);
                break;
            }
        }
    }
    getMainPot() {
        let c = 0;
        this.chairPlayers.forEach((a) => (c += a.allbet));
        return c;
    }
    checkingWinners(DealerCards?: string[], PokerPlayers?: PokerPlayer[], debugConsole?: boolean) {
        this.resetRoundBets();
        this.gamestage = GAMESTAGES.SHOWING_CARDS;
        this.time = TIMES.SHOWING_CARDS;
        this.update('players');
        this.setCurrentPlayer(null);

        if (Array.isArray(DealerCards)) this.DealerCardsProxy = DealerCards;
        if (Array.isArray(PokerPlayers)) this.chairPlayers = PokerPlayers;

        while (this.DealerCardsProxy.length < 5) {
            const randomCard = CardManager.getRandomCard(this.cardIndexesExist);
            this.DealerCardsProxy.push(randomCard);
        }

        debugConsole && console.log(`Dealer cards are: ${JSON.stringify(this.DealerCardsProxy)}`);
        debugConsole && console.log(`mainpot: ${this.getMainPot()}`);

        this.TriggerClientTablePlayers('cef_playsound', 'shuffle_cards.wav');

        this.createLog(TSL.list.reveal_cards);

        const playersNotThrowed = this.chairPlayers.filter((a) => !a.throwed);
        const winnerPlayers = get_winners(this.DealerCardsProxy, playersNotThrowed).filter((a) => a);

        debugConsole &&
            console.log(
                this.chairPlayers.map((a) => {
                    return {
                        chips: a.chips,
                        source: a.source,
                        allbet: a.allbet,
                    };
                })
            );

        if (winnerPlayers.length > 1) {
            let bets = playersNotThrowed.map((a) => a.allbet);
            const smallestBet = bets.sort((b, c) => b - c)[0];

            debugConsole && console.log(`Smallest bet: ${smallestBet}`);
            playersNotThrowed.forEach((Player) => {
                Player.roundbet -= smallestBet;
                Player.chips += Player.allbet - smallestBet;
                Player.allbet -= Player.allbet - smallestBet;
            });

            debugConsole && console.log(`There are more winners, winner players amount: ${winnerPlayers.length}`);
            const winAmount = Math.floor(this.getMainPot() / winnerPlayers.length);
            debugConsole && console.log(`Win amount split: ${winAmount}`);
            winnerPlayers.forEach((Winner) => {
                debugConsole && console.log(`Winner source: ${Winner.source}`);
                Winner.stat_wonchips += winAmount;
                Winner.stat_wongames++;
                Winner.chips += winAmount;
                this.createLog(TSL.format(TSL.list.winner_is, [Winner.name, winAmount]));
            });
        } else if (winnerPlayers.length == 1) {
            playersNotThrowed.forEach((Player) => {
                let giveback = 0;
                winnerPlayers.forEach((Winner) => {
                    if (Player.allbet > Winner.allbet) {
                        giveback += Player.allbet - Winner.allbet;
                    }
                });
                debugConsole && console.log(`${Player.source} received back: ${giveback}`);
                Player.chips += giveback;
                Player.allbet -= giveback;
            });

            const Winner = winnerPlayers[0];
            debugConsole && console.log(`Only one winner exist, ID: ${Winner.source}`);

            const mainpot = this.getMainPot();

            Winner.stat_wonchips += mainpot;
            Winner.stat_wongames++;
            Winner.chips += mainpot;
            this.createLog(TSL.format(TSL.list.winner_is, [Winner.name, mainpot]));
        }

        debugConsole &&
            console.log(
                this.chairPlayers.map((a) => {
                    return {
                        chips: a.chips,
                        source: a.source,
                        allbet: a.allbet,
                    };
                })
            );

        this.update('players');
    }
    resetGame() {
        this.createLog(TSL.list.new_game_begins);

        this.chairPlayers.forEach((playerData) => {
            playerData.resetPlayer();
        });

        this.update('mainpot');
        this.cardIndexesExist.clear();
        this.DealerCardsProxy.splice(0, this.DealerCardsProxy.length);
        this.setCurrentPlayer(null);

        this.gamestage = GAMESTAGES.GAME_NOT_STARTED;
        this.time = TIMES.GAME_NOT_STARTED;
        this.update('all');
    }
    createLog(message: string) {
        this.LogsProxy.unshift(`${Methods.createDate()}: ${message}`);
    }
}

interface TableConfigInterface {
    id: number;
    pos: AquiverShared.Vec3;
    heading: number;
    blind: number;
}

export class PokerTableManager {
    static PokerTables = new Map<number, PokerTable>();

    static init() {
        const configTables: TableConfigInterface[] = global.exports[GetCurrentResourceName()].config_getPokerTables();

        if (configTables && Array.isArray(configTables)) {
            configTables.forEach((table) => {
                this.createTable(table);
            });
        }

        setInterval(() => {
            this.PokerTables.forEach((a) => {
                a.tickTime();
            });
        }, 1000);
    }
    static createTable(tableData: TableConfigInterface) {
        this.PokerTables.set(tableData.id, new PokerTable(tableData));
    }
    static getTable(tableId: number) {
        return this.PokerTables.get(tableId);
    }
}
