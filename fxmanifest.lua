fx_version 'bodacious'
game 'gta5'


client_scripts {
	"client.lua",
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

shared_scripts {
    '@qb-core/shared/locale.lua',
    'config.lua'
}

server_scripts { '@mysql-async/lib/MySQL.lua' }