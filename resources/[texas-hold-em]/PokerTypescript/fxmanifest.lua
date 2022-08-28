--[[
    ____2.0.1____
    * Database connection now no need to be set, we are using the mysql-async variable 'set' from the server.cfg. (mysql_connection_string)

    ____2.0.2____
    * checkingWinners debugger & fixes.

    ____2.0.21____
    obj.stats.push(`${TSL.list.stat_wonchips}: ${Player.stat_betchips}`);
    Fixed. @Gewru

    ____2.0.3____
    * aquiver module added
    * Config.TableDistance, for setting the table distance range.

    ____2.0.4___
    * Stable Aquiver Module SDK added.
    * Aquiver Module 'mysql-async' error fixed.
]]

fx_version 'adamant'

game 'gta5'

description 'Aquiver Texas Holdem Poker (Typescript)'
author 'freamee'
version '2.0.4'

server_scripts {
    'files/config.lua',
    'files/js_compiled/server.js'
}

client_scripts {
    'files/config.lua',
    'files/js_compiled/client.js',
    'files/escrow/cl_utils.lua',
    'files/escrow/client_main.lua',
}

lua54 'yes'

escrow_ignore {
    'files/config.lua'
}

dependencies {
    'pokerasztal',
    '/server:4752',
    '/gameBuild:sum',
}

ui_page 'files/html/index.html'
files { 'files/html/**' }

dependency '/assetpacks'