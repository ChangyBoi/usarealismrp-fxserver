import * as Aquiver from "@aquiversdk/server";

export interface PokerDatabaseInterface {
    uniqueId: string;
    img: string;
    stat_betchips: number;
    stat_wonchips: number;
    stat_played: number;
    stat_wongames: number;
}

export class PokerBase {
    public uniqueId: string;
    public img: string;
    public stat_betchips: number;
    public stat_played: number;
    public stat_wonchips: number;
    public stat_wongames: number;

    constructor(data: PokerDatabaseInterface) {
        this.uniqueId = data.uniqueId;
        this.img = data.img;
        this.stat_betchips = data.stat_betchips;
        this.stat_played = data.stat_played;
        this.stat_wonchips = data.stat_wonchips;
        this.stat_wongames = data.stat_wongames;
    }
}

export class PokerBaseRepository extends Aquiver.BaseDatabase<PokerBase, PokerDatabaseInterface> {
    constructor() {
        super("poker_players");
    }
    constructModel(row: PokerDatabaseInterface): PokerBase {
        return new PokerBase(row);
    }
}