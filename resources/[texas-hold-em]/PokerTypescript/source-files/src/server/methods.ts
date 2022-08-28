import * as ChanceSdk from 'chance';

export class Methods {
    private static _chance: Chance.Chance;

    static get chance() {
        if (!(this._chance instanceof ChanceSdk.Chance)) {
            this._chance = new ChanceSdk.Chance();
        }

        return this._chance;
    }
    static createDate() {
        const date = new Date();
        let hours = date.getHours(),
            minutes: string | number = date.getMinutes(),
            seconds: string | number = date.getSeconds();

        if (minutes < 10) {
            minutes = '0' + minutes;
        }
        if (seconds < 10) {
            seconds = '0' + seconds;
        }

        return `${hours}:${minutes}:${seconds}`;
    }
}