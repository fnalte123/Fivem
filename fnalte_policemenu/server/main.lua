--[[

███╗░░░███╗░█████╗░██████╗░███████╗  ██████╗░██╗░░░██╗  ███████╗███╗░░██╗░█████╗░██╗░░░░░████████╗███████╗
████╗░████║██╔══██╗██╔══██╗██╔════╝  ██╔══██╗╚██╗░██╔╝  ██╔════╝████╗░██║██╔══██╗██║░░░░░╚══██╔══╝██╔════╝
██╔████╔██║███████║██║░░██║█████╗░░  ██████╦╝░╚████╔╝░  █████╗░░██╔██╗██║███████║██║░░░░░░░░██║░░░█████╗░░
██║╚██╔╝██║██╔══██║██║░░██║██╔══╝░░  ██╔══██╗░░╚██╔╝░░  ██╔══╝░░██║╚████║██╔══██║██║░░░░░░░░██║░░░██╔══╝░░
██║░╚═╝░██║██║░░██║██████╔╝███████╗  ██████╦╝░░░██║░░░  ██║░░░░░██║░╚███║██║░░██║███████╗░░░██║░░░███████╗
╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═════╝░╚══════╝  ╚═════╝░░░░╚═╝░░░  ╚═╝░░░░░╚═╝░░╚══╝╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚══════╝
--]]                                                                                                                                                                    
MySQL = module("vrp_mysql", "MySQL")
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP", "wu_policemenu")
-------------------------------------------------------------
--                     DB COMMANDS                         --
-------------------------------------------------------------
MySQL.createCommand("vRP/skovsboellostemisss","SELECT * FROM vrp_policemenu")
MySQL.createCommand("vRP/skovsboellostemisss1","INSERT INTO vrp_policemenu (bank)VALUES (@bank)")
MySQL.createCommand("vRP/getmoney","UPDATE vrp_policemenu SET bank = @bank")
-------------------------------------------------------------
--                         HT_BASE                         --
-------------------------------------------------------------
HT = nil

TriggerEvent('HT_base:getBaseObjects', function(obj) HT = obj end)
-------------------------------------------------------------
--                         Check Money                     --
-------------------------------------------------------------
HT.RegisterServerCallback("PoliceMenu:Permission", function(source, cb, id)
    local user_id = vRP.getUserId({source})
    if vRP.hasPermission({user_id,Config.OpenPermission}) then
        perm = true
    else
        perm = false
    end
    cb(perm)
end)
-------------------------------------------------------------
--                         Give Job                        --
-------------------------------------------------------------
RegisterServerEvent("PoliceMenu:GiveJob")
AddEventHandler("PoliceMenu:GiveJob", function(nuser_id)
    if nuser_id == false then
        --Notify
    else
        vRP.addUserGroup({nuser_id, Config.betjentrank})
        print("Du modtog ranken: " .. Config.betjentrank.."")
        if Config.BrugerElevrank then
            vRP.addUserGroup({nuser_id, Config.Elevrank})
        end
    end
end)
-------------------------------------------------------------
--                         Remove Job                      --
-------------------------------------------------------------
RegisterServerEvent("PoliceMenu:RemoveJob")
AddEventHandler("PoliceMenu:RemoveJob", function(nuser_id)
    if nuser_id == false then
        --Notify
    else
        for k,v in pairs(Ranks) do
            if vRP.hasGroup({nuser_id, v.job}) then
                vRP.removeUserGroup({nuser_id, v.job})
            end
        end
    end
end)
-------------------------------------------------------------
--               Antal Penge i banken                      --
-------------------------------------------------------------
HT.RegisterServerCallback("SkovsOgwuErEnOstemiss", function(source, cb, data)
    data = {}
    MySQL.query("vRP/skovsboellostemisss", {}, function(rows, affected)
        if #rows > 0 then 
            table.insert(data, {
                amount = rows[1].bank
            })
        else
            table.insert(data, {
                amount = 0
            })
            MySQL.query("vRP/skovsboellostemisss1", {bank = 0})
        end
        cb(data)
    end)
end)
-------------------------------------------------------------
--                      Indsæt Penge                       --
-------------------------------------------------------------
RegisterServerEvent("GiveMoney")
AddEventHandler("GiveMoney", function(money)
    local source = source
    local user_id = vRP.getUserId({source})
	if vRP.tryFullPayment({user_id, money}) then
    	MySQL.query("vRP/skovsboellostemisss", {}, function(rows, affected)
       		if #rows > 0 then
				money = tonumber(rows[1].bank + money)
				MySQL.query("vRP/getmoney", {bank = money})
			end
        end)
    end
end)
-------------------------------------------------------------
--                      Hæv Penge                          --
-------------------------------------------------------------
RegisterServerEvent("GetMoney")
AddEventHandler("GetMoney", function(getmoney)
    local source = source
	local user_id = vRP.getUserId({source})
	local accountMoney = 0
	MySQL.query("vRP/skovsboellostemisss", {}, function(rows, affected)
		if #rows >0 then
			money = tonumber(rows[1].bank - getmoney)
			if money >= 0 then
				vRP.giveBankMoney({user_id, getmoney})
				MySQL.query("vRP/getmoney", {bank = money})
			end
		end
    end)
end)
-------------------------------------------------------------
--                      Jail                               --
-------------------------------------------------------------
RegisterServerEvent("JailPlayer")
AddEventHandler("JailPlayer", function()
	local player = source
	vRPclient.getNearestPlayers(player,{15},function(nplayers) 
	local user_list = ""
    for k,v in pairs(nplayers) do
	  user_list = user_list .. "[" .. vRP.getUserId({k}) .. "]" .. GetPlayerName(k) .. " | "
    end 
	if user_list ~= "" then
	  vRP.prompt({player,"Spillere tæt på:" .. user_list,"",function(player,target_id) 
	    if target_id ~= nil and target_id ~= "" then 
	      vRP.prompt({player,"Fængselsstraf i minutter:","1",function(player,jail_time)
			if jail_time ~= nil and jail_time ~= "" then 
	          local target = vRP.getUserSource({tonumber(target_id)})
			  if target ~= nil then
		        if tonumber(jail_time) < 1 then
		          jail_time = 1
		        end
					vRPclient.isHandcuffed(target,{}, function(handcuffed)  
					if handcuffed then 
						SetTimeout(15000,function()
						end)
						vRPclient.setHandcuffed(target,{true})
						vRPclient.teleport(target,{1670.8273925781,2618.3583984375,53.190883636475}) -- teleport to inside jail
						--TriggerClientEvent("pNotify:SendNotification", target,{text ="Du blev fængslet.", type = "warning", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
						TriggerClientEvent("pNotify:SendNotification", player,{text ="Du sendte en person i fængsel.", type = "info", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
						vRP.setHunger({tonumber(target_id),0})
						vRP.setThirst({tonumber(target_id),0})
						jail_clock(tonumber(target_id),tonumber(jail_time))
						local user_id = vRP.getUserId({player})
						Citizen.Wait(5000)
						vRPclient.setHandcuffed(target,{false})
						TriggerClientEvent("wu:jailcloth", target)
						PerformHttpRequest('https://discordapp.com/api/webhooks/746536302098251796/mpyoGuoIEMY1W90aaY8dcpQFnfIbR8Q6qR9McvX2upTyL0SWWqAUAk3zbf1y33T-h4AY', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0"), content = user_id .. " fængslede "..target_id.." i " .. jail_time .. " minutter"}), { ['Content-Type'] = 'application/json' })
					else
						TriggerClientEvent("pNotify:SendNotification", player,{text ="Ikke i håndjern.", type = "error", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
						end
						end)
					else
						TriggerClientEvent("pNotify:SendNotification", player,{text ="Ugyldigt ID.", type = "error", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
					end
					else
						TriggerClientEvent("pNotify:SendNotification", player,{text ="Varighed på dommen ikke indtastet.", type = "error", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
					end
				end})
				else
					TriggerClientEvent("pNotify:SendNotification", player,{text ="Intet spiller ID valgt.", type = "error", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
				end 
			end})
			else
				TriggerClientEvent("pNotify:SendNotification", player,{text ="Ingen spiller tæt på.", type = "error", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
			end 
		end)
end)

-------------------------------------------------------------
--                      UNJail                             --
-------------------------------------------------------------

fodting = "aktiv"

local unjailed = {}
function jail_clock(target_id,timer)
  local target = vRP.getUserSource({tonumber(target_id)})
  local users = vRP.getUsers({})
  local online = false
  for k,v in pairs(users) do
	if tonumber(k) == tonumber(target_id) then
	  online = true
	end
  end
  if online then
    if timer > 0 then
	  TriggerClientEvent("pNotify:SendNotification", target,{text ="Tid tilbage: "..timer.." minut(ter).", type = "info", queue = "global",timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
      vRP.setUData({tonumber(target_id),"vRP:jail:time",json.encode(timer)})
	  SetTimeout(60*1000, function()
		for k,v in pairs(unjailed) do -- check if player has been unjailed by cop or admin
		  if v == tonumber(target_id) then
	        unjailed[v] = nil
		    timer = 0
		  end
		end
	    jail_clock(tonumber(target_id),timer-1)
	  end) 
    else 
	  SetTimeout(15000,function()
	  end)
	  if fodting == "aktiv" then 
		vRPclient.teleport(target,{1847.3647460938,2586.0134277344,45.672016143799}) -- teleport to outside jail
	  end
	  vRPclient.setHandcuffed(target,{false})
	  vRP.removeUserGroup({tonumber(target_id),"jailed"})
	  TriggerClientEvent("pNotify:SendNotification", target,{text ="Du blev løsladt.", type = "info", queue = "global",timeout = 4000, layout = "bottomCenter",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
	  vRP.setUData({tonumber(target_id),"vRP:jail:time",json.encode(-1)})
    end
  end
end


RegisterServerEvent("unJailPlayer")
AddEventHandler("unJailPlayer", function()
--local ch_unjail = {function(player,choice) 
local player = source
	vRP.prompt({player,"Player ID:","",function(player,target_id) 
	  if target_id ~= nil and target_id ~= "" then 
		vRP.getUData({tonumber(target_id),"vRP:jail:time",function(value)
		  if value ~= nil then
		  custom = json.decode(value)
			if custom ~= nil then
			  local user_id = vRP.getUserId({player})
			  if tonumber(custom) > 0 or vRP.hasPermission({user_id,"admin.easy_unjail"}) then
	            local target = vRP.getUserSource({tonumber(target_id)})
				if target ~= nil then
	            	unjailed[target] = tonumber(target_id)
					TriggerClientEvent("pNotify:SendNotification", player,{text ="Personen bliver snart løsladt.", type = "info", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
					TriggerClientEvent("pNotify:SendNotification", target,{text ="Din straf blev sat ned.", type = "success", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
					PerformHttpRequest('https://discordapp.com/api/webhooks/746536445803626497/oJ23AyTqat0p-UnFYHesztnsSO_0r3onfBByhW7BGNG_jQJJPJmAQPmb6ToFxst0XX6Z ', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0"), content = user_id .. " løsladte "..target_id.." fra en fængselsstraf på " .. custom .. " minutter"}), { ['Content-Type'] = 'application/json' })
					vRP.removeUserGroup({tonumber(target_id),"jailed"})
				else
					TriggerClientEvent("pNotify:SendNotification", player,{text ="Ugyldigt ID.", type = "error", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
				end
			  else
					TriggerClientEvent("pNotify:SendNotification", player,{text ="Spilleren er ikke i fængsel.", type = "error", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
			  end
			end
		  end
		end})
      else
			TriggerClientEvent("pNotify:SendNotification", player,{text ="Intet ID valgt.", type = "error", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
      end 
	end})
end)

-- (server) called when a logged player spawn to check for vRP:jail in user_data
AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn) 
  local target = vRP.getUserSource({user_id})
  SetTimeout(35000,function()
    local custom = {}
    vRP.getUData({user_id,"vRP:jail:time",function(value)
	  if value ~= nil then
	    custom = json.decode(value)
	    if custom ~= nil then
		  if tonumber(custom) > 0 then
			SetTimeout(15000,function()
			end)
			vRPclient.teleport(target,{1670.8273925781,2618.3583984375,53.190883636475}) -- teleport to inside jail
			TriggerClientEvent("pNotify:SendNotification", target,{text ="Du skal vidst lige afsone din straf.", type = "error", queue = "global",timeout = 4000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"},killer = true})
			vRP.setHunger({tonumber(user_id),0})
			vRP.setThirst({tonumber(user_id),0})
			PerformHttpRequest('https://discordapp.com/api/webhooks/746536640385908856/v44jZ224m39AKJkSIxa0BHI0j0Tgod8UqBY-lYL7w2CgnOed0lGEQT5_tU3EqfC1P5cn', function(err, text, headers) end, 'POST', json.encode({username = "Server " .. GetConvar("servernumber","0"), content = user_id.." blev sendt tilbage i fængsel i " .. custom .. " minutter for at færdiggøre sin straf [REJOIN]"}), { ['Content-Type'] = 'application/json' })
		    jail_clock(tonumber(user_id),tonumber(custom))
		  end
	    end
	  end
	end})
  end)
end)
-------------------------------------------------------------
--                      Cuff                               --
-------------------------------------------------------------
RegisterServerEvent("WuPolice:Cuff")
AddEventHandler("WuPolice:Cuff", function()
local player = source
local user_id = vRP.getUserId(player)
local nplayer = source
vRPclient.getNearestPlayer(player,{10},function(nplayer)
	local user_id = vRP.getUserId(nplayer)
	if user_id ~= nil then
		vRPclient.toggleHandcuff(nplayer,{})
			TriggerClientEvent("pNotify:SendNotification", source,{text = {lang.police.cuffs()}, type = "success", queue = "global", timeout = 3000, layout = "centerLeft",animation = {open = "gta_effects_fade_in", close = "gta_effects_fade_out"}})
		end
	end)
end)
