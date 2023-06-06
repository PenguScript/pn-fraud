fx_version 'cerulean'
game 'gta5'

description 'pn-fraud'
version '1.0'
author 'PenguScripts'


server_script 'server/main.lua'
client_script 'client/main.lua'
shared_scripts {
    'config.lua',
    '@oxmysql/lib/MySQL.lua'
}

escrow_ignore {
    'config.lua'
}

lua54 'yes'