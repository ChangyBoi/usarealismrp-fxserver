let x, y;
window.addEventListener('mousemove', (e) => {
    if (self.opened) {
        if (self.statgrabbed) {
            $('.poker-statistics-panel').css({
                top: e.clientY - 20 + 'px',
                left: e.clientX - 100 + 'px',
            });
        }
    }
});
window.addEventListener('mouseup', (e) => {
    if (self.opened) {
        self.HoverEffect();
        self.statgrabbed = false;
        $('.poker-statistics-panel').css({ opacity: '1.0' });
    }
});
window.addEventListener('mousedown', (e) => {
    if (self.opened) {
        if (e.target.className == 'stat-header') {
            self.HoverEffect();
            self.statgrabbed = true;
            $('.poker-statistics-panel').css({ opacity: '0.5' });
        }
    }
});

const app = new Vue({
    el: '#app',
    data: {
        development: false,
        opened: false,
        joined: false,

        timer: null,

        players: [],
        dealercards: [],
        betamount: 0,
        myPlayerSrc: null,

        currentplayer: null,
        currentaction: null,
        gamestage: null,

        mainpot: null,

        logsopened: false,
        logs: [],

        mychips: null,

        callAmount: 0,
        canpass: false,
        cancall: false,
        canthrow: false,
        canallin: false,
        canbet: false,
        disableallbuttons: false,

        notifymsg: null,
        notifytimeout: null,

        statgrabbed: false,
        statopened: false,
        statdata: null,
    },
    mounted: function () {
        if (this.development) {
            this.opened = true;
            this.gamestage = 2;
            this.joined = true;
            this.logs.push('18:02: Teszt üzenet', '19:02: Újabb üzenet');
            this.currentplayer = 2;
            this.mainpot = 100;
            this.dealercards.push('', '', '');
            this.players.push(
                {
                    src: 1,
                    cards: ['s8', 's6'],
                    throwed: false,
                    passed: false,
                    dealer: true,
                    playername: 'PLAYER-1',
                    roundbet: 100,
                    chairId: 0,
                    wasInRound: false,
                    chips: 200,
                },
                {
                    src: 2,
                    cards: ['s8', 's6'],
                    throwed: false,
                    passed: false,
                    dealer: false,
                    playername: 'PLAYER-2',
                    roundbet: 50,
                    chairId: 1,
                    wasInRound: false,
                    chips: 1500,
                    smallblind: true,
                },
                {
                    src: 3,
                    cards: ['s8', 's6'],
                    throwed: false,
                    passed: false,
                    dealer: false,
                    playername: 'PLAYER-3',
                    roundbet: 50,
                    chairId: 2,
                    wasInRound: false,
                    chips: 1000,
                    bigblind: true,
                },
                {
                    src: 4,
                    cards: ['s8', 's6'],
                    throwed: false,
                    passed: false,
                    dealer: false,
                    playername: 'PLAYER-4',
                    roundbet: 50,
                    chairId: 3,
                    wasInRound: false,
                    chips: 500,
                },
                {
                    src: 5,
                    cards: ['s8', 's6'],
                    throwed: false,
                    passed: false,
                    dealer: false,
                    playername: 'PLAYER-5',
                    roundbet: 50,
                    chairId: 4,
                    wasInRound: false,
                    chips: 500,
                }
            );
        }
    },
    computed: {
        getstats() {
            if (this.statdata) {
                return this.statdata.stats;
            } else return [];
        },
        myPlayerData() {
            return this.players.find((a) => a.src == this.myPlayerSrc);
        },
    },
    watch: {
        statopened(state) {
            if (!state) {
                this.statdata = null;
            }
        },
        opened(state) {
            if (this.development == false) {
                this.TriggerClientEvent('PokerNuiState', state);

                if (state == false) {
                    this.currentplayer = null;
                    this.currentaction = null;
                    this.gamestage = null;
                    this.mainpot = null;
                    this.dealercards = [];
                    this.players = [];
                    this.timer = null;

                    /** Reset the buttons */
                    this.canpass = false;
                    this.cancall = false;
                    this.canthrow = false;
                    this.canallin = false;
                    this.canbet = false;
                } else {
                    this.joined = false;
                }
            }
        },
    },
    methods: {
        openStatOnTarget(e, src) {
            this.SelectEffect();
            if (src == undefined) src = this.myPlayerSrc;
            if (src) {
                this.statopened = true;
                let y = e.clientY,
                    x = e.clientX;

                $('.poker-statistics-panel').css({
                    top: src == this.myPlayerSrc ? y + 50 + 'px' : y,
                    left: x,
                });

                setTimeout(() => {
                    this.TriggerServerEvent('PokerGetPlayerStatistic', src);
                }, 500);
            }
        },
        canAllIn() {
            if (this.disableallbuttons) return false;

            return this.canallin;
        },
        canThrow() {
            if (this.disableallbuttons) return false;

            return this.canthrow;
        },
        canPass() {
            if (this.disableallbuttons) return false;

            return this.canpass;
        },
        canCall() {
            if (this.disableallbuttons) return false;

            return this.cancall;
        },
        canBet() {
            if (this.disableallbuttons) return false;

            return this.canbet;
        },
        getPlayerBg(img) {
            return img || './img/avlogo.png';
        },
        async setImage() {
            this.SelectEffect();
            const { value: url } = await Swal.fire({
                title: _U('enter_url'),
                icon: 'warning',
                iconHtml: '!',
                confirmButtonText: _U('image_save'),
                cancelButtonText: _U('image_cancel'),
                showCancelButton: true,
                showCloseButton: true,
                input: 'url',
                inputPlaceholder: 'URL',
            });
            if (url) {
                this.TriggerServerEvent('PokerPlayerSetImage', url);
            }
        },
        canShowCards() {
            return this.gamestage == 2 || this.gamestage == 3 ? true : false;
        },
        HoverEffect() {
            this.PlaySound('hover.mp3');
        },
        SelectEffect() {
            this.PlaySound('select.mp3');
        },
        PlaySound(sound, volume) {
            new Howl({
                src: [`sounds/${sound}`],
                autoplay: true,
                loop: false,
                volume: volume ? volume : 0.035,
            });
        },
        Close() {
            if (this.joined) {
                if (this.gamestage == 1) return (this.opened = false);
            } else {
                this.opened = false;
            }
        },
        Notify(msg) {
            if (this.notifytimeout) {
                clearTimeout(this.notifytimeout);
                this.notifytimeout = null;
            }

            this.notifymsg = msg;
            this.PlaySound('notify.mp3');

            this.notifytimeout = setTimeout(() => {
                this.notifymsg = null;

                if (this.notifytimeout) {
                    clearTimeout(this.notifytimeout);
                    this.notifytimeout = null;
                }
            }, 4000);
        },
        getChipsImage(amount) {
            let img = 'chips.png';
            if (amount > 100) img = 'chips100.png';

            return `backgroundImage: url('img/chips/${img}')`;
        },
        getCardBg(a) {
            if (a) return `backgroundImage: url('img/deck/${a}.png')`;
            else return `backgroundImage: url('img/backblue.png')`;
        },
        TriggerServerEvent(eventName, args = {}) {
            if (typeof GetParentResourceName === 'function') {
                $.post(
                    `https://${GetParentResourceName()}/cef_to_server`,
                    JSON.stringify({
                        eventName,
                        args,
                    })
                );
            }
        },
        TriggerClientEvent(eventName, args = {}) {
            if (typeof GetParentResourceName === 'function') {
                $.post(
                    `https://${GetParentResourceName()}/cef_to_client`,
                    JSON.stringify({
                        eventName,
                        args,
                    })
                );
            }
        },
        formatMoney: function (n, c, d, t) {
            var c = isNaN((c = Math.abs(c))) ? 0 : c,
                d = d == undefined ? '.' : d,
                t = t == undefined ? ',' : t,
                s = n < 0 ? '-' : '',
                i = String(parseInt((n = Math.abs(Number(n) || 0).toFixed(c)))),
                j = (j = i.length) > 3 ? j % 3 : 0;
            return (
                s +
                (j ? i.substr(0, j) + t : '') +
                i.substr(j).replace(/(\d{3})(?=\d)/g, '$1' + t) +
                (c
                    ? d +
                      Math.abs(n - i)
                          .toFixed(c)
                          .slice(2)
                    : '')
            );
        },
    },
    template: '#app',
});

const self = app;

window.addEventListener('message', (event) => {
    if (event.data.action == 'setVariable') {
        self[event.data.key] = event.data.value;
    } else if (event.data.action == 'PokerNotify') {
        self.Notify(event.data.msg);
    } else if (event.data.action == 'PlaySound') {
        self.PlaySound(event.data.sound, event.data.volume);
    } else if (event.data.action == 'mycards') {
        let ref = self.players.find((a) => a.src == event.data.d.src);
        if (ref) {
            ref.cards = event.data.d.cards;
        }
    } else if (event.data.action == 'setTargetStat') {
        if (event.data.stat) {
            self.statdata = event.data.stat;
        } else {
            self.statopened = false;
        }
    } else if (event.data.action == 'add-log-entry') {
        self.logs.unshift(event.data.value);
    }
});

window.addEventListener('keydown', function (event) {
    if (event.key == 'Escape') {
        self.Close();
    }
});
