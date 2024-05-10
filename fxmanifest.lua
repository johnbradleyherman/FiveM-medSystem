fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'aintjb'
description 'JB Scripts | Discord link: https://discord.gg/ZyNuMCBeMh'

shared_scripts{
  '@es_extended/imports.lua',
  '@ox_lib/init.lua'
}

client_scripts {
  'client.lua',
  'config.lua'
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',
  'server.lua',
  'config.lua'
}



