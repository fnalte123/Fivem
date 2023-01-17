--[[

███╗░░░███╗░█████╗░██████╗░███████╗  ██████╗░██╗░░░██╗  ███████╗███╗░░██╗░█████╗░██╗░░░░░████████╗███████╗
████╗░████║██╔══██╗██╔══██╗██╔════╝  ██╔══██╗╚██╗░██╔╝  ██╔════╝████╗░██║██╔══██╗██║░░░░░╚══██╔══╝██╔════╝
██╔████╔██║███████║██║░░██║█████╗░░  ██████╦╝░╚████╔╝░  █████╗░░██╔██╗██║███████║██║░░░░░░░░██║░░░█████╗░░
██║╚██╔╝██║██╔══██║██║░░██║██╔══╝░░  ██╔══██╗░░╚██╔╝░░  ██╔══╝░░██║╚████║██╔══██║██║░░░░░░░░██║░░░██╔══╝░░
██║░╚═╝░██║██║░░██║██████╔╝███████╗  ██████╦╝░░░██║░░░  ██║░░░░░██║░╚███║██║░░██║███████╗░░░██║░░░███████╗
╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═════╝░╚══════╝  ╚═════╝░░░░╚═╝░░░  ╚═╝░░░░░╚═╝░░╚══╝╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚══════╝
--]]

Config = {}

Config.OpenPermission = "police.pc" -- Permission til at bruge menuen

Config.Marker = true -- Vil du have en drawmarker til menuen? Sæt den til true!

Config.Locations = {
    {name = "Police Menu", colour=3, id=351, x = 450.87457275391, y = -976.63696289063, z = 30.689599990845-1} -- Sted din drawmarker skal være!
}

Config.HotKey = true -- Vil Du have en genvej til menuen? Sæt den true!

Config.OpenHotKey = 167 -- Hotkey til menuen (F6)

Config.OpenMenu = 51 -- Key: E

Config.betjentrank =  "police-job" -- Ranket du får for at ansætte en betjent

Config.Options = {
    { mulighed = 'hire_cop', label = 'Medarbejdere Menu', Enabled = true,}, -- Ik pil ved det her, mm. du har styr på hvad du laver
    { mulighed = 'account', label = 'Statskasse', Enabled = true,}, -- Ik pil ved det her, mm. du har styr på hvad du laver
    { mulighed = 'jail_menu', label = 'Fængsel', Enabled = true,}, -- Ik pil ved det her, mm. du har styr på hvad du laver
    { mulighed = 'cuff', label = 'Håndjern', Enabled = true,}, -- Ik pil ved det her, mm. du har styr på hvad du laver
   -- { mulighed = 'fine', label = 'Bøde', Enabled = true,}, -- Ik pil ved det her, mm. du har styr på hvad du laver
    
}

Ranks = { -- Ranks det kan blive fyret!
    { job = 'Politi-Elev'}, 
    { job = 'Politi-Job'},
    { job = 'Politi-Betjent'},
    { job = 'Indstatleder'},
}
