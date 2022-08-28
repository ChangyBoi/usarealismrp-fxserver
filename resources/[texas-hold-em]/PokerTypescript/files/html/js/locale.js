const lang = 'en';
const Translations = {}

Translations['en'] = {
    // GAMESTAGES
    'GAMESTAGE-1': 'The game is starting soon...',
    'GAMESTAGE-2': 'Rounds',
    'GAMESTAGE-3': 'Revealing cards...',

    'button_allin': 'All-in',
    'button_throw': 'Throw',
    'button_pass': 'Check',
    'button_bet': 'Bet',
    'button_call': 'Call',
    'amount': 'Amount',
    'join': 'Join',
    'open_log': 'Game log',
    'my_statistics': 'My statistics',

    'enter_url': 'Please enter the image url.',
    'image_save': 'Save',
    'image_cancel': 'Cancel',
    'change_image': 'Change avatar',
    'bet_placeholder': 'Amount'
}

function _U(a) {
    try {
        return Translations[lang][a] || 'UNKNOWN_TRANSLATION';
    }
    catch {
        return 'UNKOWN_TRANSLATION';
    }
}