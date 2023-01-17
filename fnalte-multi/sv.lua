--[[

███╗░░░███╗░█████╗░██████╗░███████╗  ██████╗░██╗░░░██╗  ███████╗███╗░░██╗░█████╗░██╗░░░░░████████╗███████╗
████╗░████║██╔══██╗██╔══██╗██╔════╝  ██╔══██╗╚██╗░██╔╝  ██╔════╝████╗░██║██╔══██╗██║░░░░░╚══██╔══╝██╔════╝
██╔████╔██║███████║██║░░██║█████╗░░  ██████╦╝░╚████╔╝░  █████╗░░██╔██╗██║███████║██║░░░░░░░░██║░░░█████╗░░
██║╚██╔╝██║██╔══██║██║░░██║██╔══╝░░  ██╔══██╗░░╚██╔╝░░  ██╔══╝░░██║╚████║██╔══██║██║░░░░░░░░██║░░░██╔══╝░░
██║░╚═╝░██║██║░░██║██████╔╝███████╗  ██████╦╝░░░██║░░░  ██║░░░░░██║░╚███║██║░░██║███████╗░░░██║░░░███████╗
╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═════╝░╚══════╝  ╚═════╝░░░░╚═╝░░░  ╚═╝░░░░░╚═╝░░╚══╝╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚══════╝
--]]


local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","fnalte-multichar")
local c=module("cfg/identity")

startpos = c.city_hall


HT = nil

TriggerEvent('HT_base:getBaseObjects', function(obj) HT = obj end)


HT.RegisterServerCallback("fnalte:GetUserIds", function(source, cb)
	local source = source
    local ids = GetPlayerIdentifiers(source)
    local users = {}
    if ids ~= nil and #ids > 0 then
        vRP.getUserIdByIdentifiers({ids, function(user_id)
            if user_id ~= false then
                vRP.getUserNames({user_id, function(charnames)
                    local user_id = tonumber(charnames[1][2])
                    local user_id2 = tonumber(charnames[2][2])  
                    local user_id3 = tonumber(charnames[3][2])  
                    table.insert(users, {
                        user1 = user_id,
                        user2 = user_id2,
                        user3 = user_id3,
                    }) 
                cb(users)
                end})
            end
        end})
    end
end)


HT.RegisterServerCallback("fnalte:GetuserNames", function(source, cb, users)
    for k,v in pairs(users) do
        user_id = v.user1
        user_id2 = v.user2
        user_id3 = v.user3
    end
    MySQL.Async.fetchAll('SELECT * FROM vrp_user_identities WHERE user_id = @user_id', {user_id = user_id}, function(data)
        if #data >0 then
            if data[1].firstname == "Skift" then
                id1 = "newply"
            else
                id1 = "old"
            end
            MySQL.Async.fetchAll('SELECT * FROM vrp_user_identities WHERE user_id = @user_id', {user_id = user_id2}, function(data)
                if #data >0 then
                    if data[1].firstname == "Skift" then
                        id2 = "newply"
                    else
                        id2 = "old"
                    end
                    MySQL.Async.fetchAll('SELECT * FROM vrp_user_identities WHERE user_id = @user_id', {user_id = user_id3}, function(data)
                        if #data >0 then
                            if data[1].firstname == "Skift" then
                                id3 = "newply"
                            else
                                id3 = "old"
                            end
                        end
                        cb(id1, id2, id3)
                    end)
                end
            end)
        end
    end)                              
end)


RegisterServerEvent("fnalte:SetId")
AddEventHandler("fnalte:SetId", function(user_id, idx)
    local source = source
    local steamname = (GetPlayerName(source))
    vRP.setUserId({source, user_id, steamname})
    local user_id = vRP.getUserId({source})
    TriggerClientEvent("fnalte:changeCam", source)
    TriggerEvent('t1ger_mechanicjob:fetchMechShops', source)
    if idx == "newply" then 
        TriggerClientEvent("jsfour-register:open", source)
    end
end)

HT.RegisterServerCallback('fnalte:GetPosition', function(source, cb, data)
	MySQL.Async.fetchScalar('SELECT dvalue FROM vrp_user_data WHERE user_id = @user_id AND dkey = @key', {
		['@user_id'] = data,
		['@key'] = "vRP:datatable"
	}, function(result)
		result = json.decode(result)
		cb(result, startpos)
	end)
end)


HT.RegisterServerCallback('fnalte:getPlayerSkin', function(source, cb, users)
    local user_id = vRP.getUserId({source})
    MySQL.Async.fetchAll('SELECT * FROM vrp_user_identities WHERE user_id = @user_id', {
        ['@user_id'] = user_id
    }, function(users)
        local user = users[1]
        local skin = nil


        if user.skin ~= nil then
            data = json.decode(user.skin)
        end
        cb(data)
    end)
end)



function LuaEncode(t)
    if type(t) == "vector3" then
        t = {x = t.x, y = t.y, z = t.z}
    end
    local ts = "{"
    for k,v in pairs(t) do
        if type(v) == "table" or type(v) == "vector3" then
           v = LuaEncode(v) 
        end
        if type(k) == "string" then
           k = '"'..k..'"' 
        end
        ts = ts.." ["..k.."] = "..v..","
    end
    ts = ts:sub(1, -2).." }"
    return ts
end
