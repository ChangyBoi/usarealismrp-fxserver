import * as Aquiver from "@aquiversdk/client";
Aquiver.Config.Framework = 'CUSTOM';

/** This is not needed, but for safety, i created it. */
class Player extends Aquiver.ClientPlayer<{}> {
    constructor() {
        super();
    }
}
new Player();
