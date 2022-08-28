import * as Aquiver from "@aquiversdk/server";
import { TSL } from '../shared/locales';
import { PokerDatabaseInterface } from './Database/models/model-player';
import { ServerDatabase } from './Database/server-database';
import { CHAIRS, PokerTableManager } from './poker';

export class PokerPlayer extends Aquiver.ServerPlayer<{}, {}> {
    private _tableId: number | null;
    /** Actual round bet amount */
    private _roundbet: number = 0;
    /** All bet amount at the table. */
    private _allbet: number = 0;

    public cards: string[] = [];
    public throwed: boolean = false;
    public passed: boolean = false;
    public dealer: boolean = false;
    public allined: boolean = false;
    public wasInRound: boolean = false;
    public smallblind: boolean = false;
    public bigblind: boolean = false;
    public chairId: number;

    public data: Partial<PokerDatabaseInterface> = {};

    constructor(source: any) {
        super(source);

        this.load();

        console.log(this.chips);
    }

    private async load() {
        const exist = await ServerDatabase.PokerRepository.exist({
            uniqueId: this.uniqueId,
        });
        if (exist) {
            ServerDatabase.PokerRepository.find({
                where: {
                    uniqueId: this.uniqueId,
                },
                limit: 1,
            }).then((a) => {
                const data = a[0];
                this.img = data.img;
                this.stat_betchips = data.stat_betchips;
                this.stat_played = data.stat_played;
                this.stat_wonchips = data.stat_wonchips;
                this.stat_wongames = data.stat_wongames;
            });
        } else {
            ServerDatabase.PokerRepository.insert({
                uniqueId: this.uniqueId,
                stat_betchips: 0,
                stat_played: 0,
                stat_wonchips: 0,
                stat_wongames: 0,
            }).then(() => {
                this.load();
            });
        }
    }

    resetPlayer() {
        this.cards = [];
        this.throwed = false;
        this.passed = false;
        this.dealer = false;
        this.allined = false;
        this.wasInRound = false;
        this.smallblind = false;
        this.bigblind = false;
        this.roundbet = 0;
        this.allbet = 0;
    }
    get allbet() {
        return this._allbet;
    }
    set allbet(amount: number) {
        this._allbet = amount;

        if (this.isPlayerPlayingAtTable()) {
            let Table = this.getPlayerTable();
            if (Table) {
                Table.update('mainpot');
            }
        }
    }
    get roundbet() {
        return this._roundbet;
    }
    set roundbet(amount: number) {
        this._roundbet = amount;
    }
    get tableId() {
        return this._tableId;
    }
    /** This is when the player opens the Poker table. */
    set tableId(tableIndex: number | null) {
        if (tableIndex !== null) {
            let Table = PokerTableManager.getTable(tableIndex);
            if (Table) {
                Table.playersOpened.push(this);
                Table.update('all');
                this.triggerClient('setCefVariable', 'myPlayerSrc', this.source);
                this.triggerClient('setCefVariable', 'mychips', this.chips);
            }
        } else {
            let Table = this.getPlayerTable();
            if (Table) {
                const idx = Table.playersOpened.findIndex((a) => a.source == this.source);
                if (idx >= 0) {
                    Table.playersOpened.splice(idx, 1);
                }

                if (this.isPlayerPlayingAtTable()) {
                    const { offset, heading } = CHAIRS[this.chairId];
                    this.triggerClient('AquiverTexasPoker:standUpClient', Table.id, offset, heading);
                    let PokerPlayer = Table.getPlayerChairData(this);
                    Table.throwPoker(PokerPlayer, true);

                    const idx = Table.chairPlayers.findIndex((a) => a.chairId == this.chairId);
                    if (idx >= 0) {
                        Table.chairPlayers.splice(idx, 1);
                    }
                    Table.createLog(TSL.format(TSL.list.player_leaved, [this.name]));
                    Table.update('players');
                }

                this.resetPlayer();
                this.triggerClient('setCefVariable', 'opened', false);
            }
        }

        /** Need to be here */
        this._tableId = tableIndex;
    }
    getPlayerTable() {
        return PokerTableManager.getTable(this.tableId);
    }
    isPlayerPlayingAtTable() {
        try {
            return PokerTableManager.getTable(this.tableId).chairPlayers.find((a) => a.source == this.source);
        } catch {
            return false;
        }
    }
    get img() {
        return this.data.img;
    }
    set img(url: string) {
        this.data.img = url;

        ServerDatabase.PokerRepository.update({
            where: {
                uniqueId: this.uniqueId,
            },
            set: {
                img: this.img,
            },
        });

        if (this.isPlayerPlayingAtTable()) {
            let Table = this.getPlayerTable();
            if (Table) {
                Table.update('players');
            }
        }
    }
    get stat_betchips() {
        return this.data.stat_betchips;
    }
    set stat_betchips(amount: number) {
        this.data.stat_betchips = amount;

        ServerDatabase.PokerRepository.update({
            where: {
                uniqueId: this.uniqueId,
            },
            set: {
                stat_betchips: this.stat_betchips,
            },
        });
    }
    get stat_wonchips() {
        return this.data.stat_wonchips;
    }
    set stat_wonchips(amount: number) {
        this.data.stat_wonchips = amount;

        ServerDatabase.PokerRepository.update({
            where: {
                uniqueId: this.uniqueId,
            },
            set: {
                stat_wonchips: this.stat_wonchips,
            },
        });
    }
    get stat_played() {
        return this.data.stat_played;
    }
    set stat_played(amount: number) {
        this.data.stat_played = amount;

        ServerDatabase.PokerRepository.update({
            where: {
                uniqueId: this.uniqueId,
            },
            set: {
                stat_played: this.stat_played,
            },
        });
    }
    get stat_wongames() {
        return this.data.stat_wongames;
    }
    set stat_wongames(amount: number) {
        this.data.stat_wongames = amount;

        ServerDatabase.PokerRepository.update({
            where: {
                uniqueId: this.uniqueId,
            },
            set: {
                stat_wongames: this.stat_wongames,
            },
        });
    }

    toNUIObject() {
        return {
            src: this.source,
            cards: this.cards,
            throwed: this.throwed,
            passed: this.passed,
            dealer: this.dealer,
            playername: this.name,
            roundbet: this.roundbet,
            chairId: this.chairId,
            wasInRound: this.wasInRound,
            chips: this.chips,
            img: this.img,
            allined: this.allined,
        };
    }

    get chips() {
        if (Aquiver.Config.ResourceExtra.useItems) {
            return this.getItemAmount(Aquiver.Config.ResourceExtra.selectedItem);
        } else {
            return this.getAccountMoney(Aquiver.Config.ResourceExtra.selectedAccount);
        }
    }

    set chips(amount: number) {
        if (Aquiver.Config.ResourceExtra.useItems) {
            const oldChips = this.chips;
            /** Negative */
            if (oldChips > amount) {
                const diff = Math.abs(oldChips - amount);
                this.removeItem(Aquiver.Config.ResourceExtra.selectedItem, diff);
            } else if (amount > oldChips) {
                /** Positive, because the new amount is higher then the old one, so give item. */
                const diff = Math.abs(amount - oldChips);
                this.addItem(Aquiver.Config.ResourceExtra.selectedItem, diff);
            }
        } else {
            this.setAccountMoney(Aquiver.Config.ResourceExtra.selectedAccount, amount);
        }

        if (this.isPlayerPlayingAtTable()) {
            this.triggerClient('setCefVariable', 'mychips', this.chips);
        }
    }
}

export class PlayerManager {
    static Players = new Map<number, PokerPlayer>();

    static async addPlayer(source: string | number) {
        let Player = new PokerPlayer(source);
        this.Players.set(Number(source), Player);
    }
    static dropPlayer(source: string | number) {
        let Player = this.getPlayer(source);
        if (Player) {
            Player.tableId = null;
            this.Players.delete(source as number);
        }
    }
    static getPlayer(source: string | number) {
        if (typeof source !== 'number') source = parseInt(source);

        let Player = this.Players.get(source);
        if (Player && Player.exist()) {
            return Player;
        }
    }
    static getPlayerStatistic(source: string | number) {
        let obj: { name: string; stats: string[] } = {
            name: 'TBD',
            stats: [],
        };
        try {
            let Player = this.getPlayer(source);

            obj.name = Player.name;

            obj.stats.push(`${TSL.list.stat_wonchips}: ${Player.stat_wonchips}`);
            obj.stats.push(`${TSL.list.stat_wongames}: ${Player.stat_wongames}`);
            obj.stats.push(`${TSL.list.stat_played}: ${Player.stat_played}`);
            obj.stats.push(`${TSL.list.stat_betchips}: ${Player.stat_betchips}`);

            let winratecalc = (Player.stat_wongames / Player.stat_played) * 100;
            if (isNaN(winratecalc)) winratecalc = 0;
            obj.stats.push(`${TSL.list.stat_winrate}: ${winratecalc.toFixed(2)}%`);

            return obj;
        } catch {
            return null;
        }
    }
}
