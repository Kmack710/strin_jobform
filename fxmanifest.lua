fx_version 'adamant'
game 'gta5'

ui_page "html/index.html"

shared_script 'config.lua'

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua',
    'sconfig.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/index.js'
}
