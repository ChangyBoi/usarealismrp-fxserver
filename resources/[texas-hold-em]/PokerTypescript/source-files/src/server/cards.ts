import { Methods } from './methods';

export class CardManager {
    static Cards: Record<number, string> = {};

    static init() {
        var i;
        var j = 0;
        for (i = 2; i < 15; i++) {
            this.Cards[j++] = 'h' + i;
            this.Cards[j++] = 'd' + i;
            this.Cards[j++] = 'c' + i;
            this.Cards[j++] = 's' + i;
        }
    }
    static getRandomCard(existCards: Set<number>) {
        const c = Object.keys(this.Cards).length - 1;
        let r = Methods.chance.integer({ min: 0, max: c });
        while (existCards.has(r)) {
            r = Methods.chance.integer({ min: 0, max: c });
        }
        existCards.add(r);
        return this.Cards[r];
    }
}

setImmediate(() => {
    CardManager.init();
});
