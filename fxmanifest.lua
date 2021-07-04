fx_version 'adamant'
game 'gta5'

ui_page "html/index.html"

shared_script '@qb-core/import.lua'

client_scripts {
    'client.lua',
    'config.lua'
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
