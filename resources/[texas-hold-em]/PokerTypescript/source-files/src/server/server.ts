import * as Aquiver from "@aquiversdk/server";
import { PlayerManager } from './player';

Aquiver.Config.Framework = 'CUSTOM';
Aquiver.Config.SqlDebug = true;
/** Select your mysql resource handler. */
Aquiver.Config.sqlResource = 'mysql-async';
/** Set it to false if you want to use accounts like: bank, black_money, etc. */
Aquiver.Config.ResourceExtra.useItems = false;
/** Selected account type, leave it if you use the resource with items. */
Aquiver.Config.ResourceExtra.selectedAccount = "bank";
/** Selected item type, leave it if you use the resource with accounts. */
Aquiver.Config.ResourceExtra.selectedItem = "chips";

setImmediate(() => {
    switch (Aquiver.Config.Framework) {
        case 'ESX_LEGACY': {
            onNet(Aquiver.Events.ESX.PlayerLoaded, (sourceId) => {
                PlayerManager.addPlayer(sourceId);
            });
            break;
        }
        case 'QBCORE': {
            onNet(Aquiver.Events.QBCORE.PlayerLoaded, (QBPlayer: QBCore_Player) => {
                PlayerManager.addPlayer(QBPlayer.PlayerData.source);
            });
            break;
        }
        case 'CUSTOM': {
            onNet('playerJoining', () => {
                PlayerManager.addPlayer(globalThis.source);
            });
            break;
        }
    }
});

import "./events";

