fx_version 'cerulean'
game 'gta5'

author 'Yibtag'
version '1.0.0'

lua54 'yes'

shared_script 'config.lua'
client_script 'client.lua'
server_script 'server.lua'

ui_page 'web/index.html'

files {
    'web/fivem.js',
    'web/index.js',
    'web/index.css',
    'web/index.html',
    'stream/yibtag_smart_watch.ytyp',
    'stream/prop_yibtag_smart_watch.ydr',
    'stream/yibtag_smart_watch@inspect.ycd'
}

data_file 'DLC_ITYP_REQUEST' 'stream/yibtag_smart_watch.ytyp'

dependencies {
    'community_bridge'
}