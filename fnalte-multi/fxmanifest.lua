--[[

███╗░░░███╗░█████╗░██████╗░███████╗  ██████╗░██╗░░░██╗  ███████╗███╗░░██╗░█████╗░██╗░░░░░████████╗███████╗
████╗░████║██╔══██╗██╔══██╗██╔════╝  ██╔══██╗╚██╗░██╔╝  ██╔════╝████╗░██║██╔══██╗██║░░░░░╚══██╔══╝██╔════╝
██╔████╔██║███████║██║░░██║█████╗░░  ██████╦╝░╚████╔╝░  █████╗░░██╔██╗██║███████║██║░░░░░░░░██║░░░█████╗░░
██║╚██╔╝██║██╔══██║██║░░██║██╔══╝░░  ██╔══██╗░░╚██╔╝░░  ██╔══╝░░██║╚████║██╔══██║██║░░░░░░░░██║░░░██╔══╝░░
██║░╚═╝░██║██║░░██║██████╔╝███████╗  ██████╦╝░░░██║░░░  ██║░░░░░██║░╚███║██║░░██║███████╗░░░██║░░░███████╗
╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═════╝░╚══════╝  ╚═════╝░░░░╚═╝░░░  ╚═╝░░░░░╚═╝░░╚══╝╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚══════╝
--]]


fx_version "adamant"
game "gta5"


server_scripts {
    '@mysql-async/lib/MySQL.lua',
    '@vrp/lib/utils.lua',
    "cfg.lua",
    "sv.lua",
}

client_scripts {
    "cfg.lua",
	"cl.lua",
}
