import { PlayerManager } from './player';
import { PokerTableManager } from './poker';

/** Main script initer. */
onNet('onResourceStart', (resource: string) => {
    if (GetCurrentResourceName() !== resource) return;

    /** Create the poker tables. */
    PokerTableManager.init();

    const players = getPlayers();
    players.forEach((src) => {
        PlayerManager.addPlayer(src);
    });
});
onNet('playerDropped', () => {
    PlayerManager.dropPlayer(global.source);
});
onNet('PokerNuiState', (tableId: number, state: boolean) => {
    try {
        PlayerManager.getPlayer(global.source).tableId = tableId;
    } catch (e) {
        console.warn(e);
    }
});
onNet('PokerJoinPlayer', () => {
    try {
        let Player = PlayerManager.getPlayer(global.source);
        let Table = Player.getPlayerTable();
        Table.joinPlayer(Player);
    } catch (e) {
        console.warn(e);
    }
});
onNet('PokerAllIn', () => {
    try {
        let Player = PlayerManager.getPlayer(global.source);
        if (!Player.isPlayerPlayingAtTable()) return;
        let Table = Player.getPlayerTable();
        Table.allInPoker(Player);
    } catch (e) {
        console.warn(e);
    }
});
onNet('PokerFold', () => {
    try {
        let Player = PlayerManager.getPlayer(global.source);
        if (!Player.isPlayerPlayingAtTable()) return;
        let Table = Player.getPlayerTable();
        Table.throwPoker(Player);
    } catch (e) {
        console.warn(e);
    }
});
onNet('PokerPass', () => {
    try {
        let Player = PlayerManager.getPlayer(global.source);
        if (!Player.isPlayerPlayingAtTable()) return;
        let Table = Player.getPlayerTable();
        Table.passPoker(Player);
    } catch (e) {
        console.warn(e);
    }
});
onNet('PokerCall', () => {
    try {
        let Player = PlayerManager.getPlayer(global.source);
        if (!Player.isPlayerPlayingAtTable()) return;
        let Table = Player.getPlayerTable();
        Table.callPoker(Player);
    } catch (e) {
        console.warn(e);
    }
});
onNet('PokerBet', (amount: number) => {
    try {
        let Player = PlayerManager.getPlayer(global.source);
        if (!Player.isPlayerPlayingAtTable()) return;
        let Table = Player.getPlayerTable();
        Table.betPoker(Player, amount);
    } catch (e) {
        console.warn(e);
    }
});
onNet('PokerPlayerSetImage', (url: string) => {
    try {
        PlayerManager.getPlayer(global.source).img = url;
    } catch (e) {
        console.warn(e);
    }
});
onNet('PokerGetPlayerStatistic', (src: number | string) => {
    try {
        let Player = PlayerManager.getPlayer(global.source);

        const TargetStats = PlayerManager.getPlayerStatistic(src);
        Player.triggerClient('PokerSetTargetStatistic', TargetStats);
    } catch (e) {
        console.warn(e);
    }
});
