-- Generated automaticly by RB Generator.
fx_version('cerulean')
games({ 'gta5' })



server_scripts({
    'server.lua',
    '@oxmysql/lib/MySQL.lua'
});



shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts({
    'client.lua'
});


lua54 'yes'

