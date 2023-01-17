Udgivet takket være leaking

MathiasDEV#3676 er i dette tilfælde den skyldige. Er der nogle som ligger inde med noget information på ham, må i hellere end gerne skrive til mig på discord

Jeg har pillet UI delen ud, da jeg ikke har fået lov til at tage det med i udgivelsen

Replace i Base.lua
OBS:
Det eneste jeg har lavet i denne fil er vRP.setUserId funktionen. Dog er der flere af tingene som er nødvendige for at få det hele til at virke. 
Kan du ikke selv sætte det op, kan du i værste fald DM mig på discord
Fnalzito#9444



--MySQL = module("vrp_mysql", "MySQL")

local Proxy = module("lib/Proxy")
local Tunnel = module("lib/Tunnel")
local Lang = module("lib/Lang")
Debug = module("lib/Debug")

local config = module("cfg/base")
local version = module("version")
Debug.active = config.debug
-- versioning
print("[vRP] launch version "..version)
--[[
PerformHttpRequest("https://raw.githubusercontent.com/ImagicTheCat/vRP/master/vrp/version.lua",function(err,text,headers)
  if err == 0 then
    text = string.gsub(text,"return ","")
    local r_version = tonumber(text)
    if version ~= r_version then
      print("[vRP] WARNING: A new version of vRP is available here https://github.com/ImagicTheCat/vRP, update to benefit from the last features and to fix exploits/bugs.")
    end
  else
    print("[vRP] unable to check the remote version")
  end
end, "GET", "")
--]]

vRP = {}
Proxy.addInterface("vRP",vRP)

tvRP = {}
Tunnel.bindInterface("vRP",tvRP) -- listening for client tunnel

-- load language 
local dict = module("cfg/lang/"..config.lang) or {}
vRP.lang = Lang.new(dict)

-- init
vRPclient = Tunnel.getInterface("vRP","vRP") -- server -> client tunnel
vRPex = Proxy.getInterface("vrp-extended")
vRPanim = Tunnel.getInterface("dylantic-animation","vRP") -- server -> client tunnel

vRP.users = {} -- will store logged users (id) by first identifier
vRP.rusers = {} -- store the opposite of users
vRP.user_tables = {} -- user data tables (logger storage, saved to database)
vRP.user_tmp_tables = {} -- user tmp data tables (logger storage, not saved)
vRP.user_sources = {} -- user sources 

MySQL.ready(function ()
  MySQL.Async.execute([[
CREATE TABLE IF NOT EXISTS vrp_users(
  id INTEGER AUTO_INCREMENT,
  last_login VARCHAR(255),
  whitelisted BOOLEAN,
  banned BOOLEAN,
  CONSTRAINT pk_user PRIMARY KEY(id)
);

CREATE TABLE IF NOT EXISTS vrp_user_ids(
  identifier VARCHAR(255),
  user_id INTEGER,
  CONSTRAINT pk_user_ids PRIMARY KEY(identifier),
  CONSTRAINT fk_user_ids_users FOREIGN KEY(user_id) REFERENCES vrp_users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS vrp_user_data(
  user_id INTEGER,
  dkey VARCHAR(255),
  dvalue TEXT,
  CONSTRAINT pk_user_data PRIMARY KEY(user_id,dkey),
  CONSTRAINT fk_user_data_users FOREIGN KEY(user_id) REFERENCES vrp_users(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS vrp_srv_data(
  dkey VARCHAR(255),
  dvalue TEXT,
  CONSTRAINT pk_srv_data PRIMARY KEY(dkey)
);
]], nil, function(rowsChanged)
  end)
end)

-- init tables
print("[vRP] init base tables")

-- identification system

function vRP.getUserIdByIdentifiers(ids, cbr)
	local curChars = 0

	if ids ~= nil and #ids then
		local i = 0
		local userTable = {
						{user_id = 0},
						{user_id = 0},
						{user_id = 0}
					}
		local validids = 0
		local function search()
			i = i+1
			if i <= #ids then
					if (not config.ignore_ip_identifier or (string.find(ids[i], "ip:") == nil)) and					

						(not config.ignore_license_identifier or (string.find(ids[i], "license:") == nil)) and

						(not config.ignore_xbox_identifier or (string.find(ids[i], "xbl:") == nil)) and				

						(not config.ignore_discord_identifier or (string.find(ids[i], "discord:") == nil)) and					

						(not config.ignore_live_identifier or (string.find(ids[i], "live:") == nil)) and
	
						(not config.ignore_fivem_identifier or (string.find(ids[i], "fivem:") == nil)) then

			
					validids = validids + 1
          MySQL.Async.fetchAll("SELECT user_id FROM vrp_user_ids WHERE identifier = @identifier", {identifier = ids[i]}, function(rows, affected)
						if #rows > 2 then 
							cbr(rows)
						elseif #rows > 0 then 
							curChars = #rows
							for z=1, curChars do
								userTable[z].user_id = rows[z].user_id
							end
							search()
						else
							search()
						end
					end)
				else
					search()
				end
			elseif validids > 0 then 
        if findIfSteam(ids) then
          for i=1+curChars, 3 do

          MySQL.Async.insert("INSERT INTO vrp_users(whitelisted,banned) VALUES(false,false)", {}, function(lastID)
            if lastID ~= nil then
              local user_id = lastID

                              for l,w in pairs(ids) do
                              --[[if  (not config.ignore_ip_identifier or (string.find(w, "ip:") == nil)) and

                                  (not config.ignore_license_identifier or (string.find(w, "license:") == nil)) and

                                  (not config.ignore_xbox_identifier or (string.find(w, "xbl:") == nil)) and

                                  (not config.ignore_discord_identifier or (string.find(w, "discord:") == nil)) and

                                  (not config.ignore_live_identifier or (string.find(w, "live:") == nil)) and  -- ignore ip & license identifier
                                  (not config.ignore_fivem_identifier or (string.find(w, "fivem:") == nil)) then]]
                                      if string.find(w, "steam:") ~= nil then
                                        MySQL.Async.execute("INSERT INTO vrp_user_ids SET identifier = @identifier, user_id = @user_id", {identifier = w, user_id = user_id})
                                      end
                end
                userTable[i].user_id = user_id
          
            
              end
            end)
          end
        else
          userTable = false
        end
				Wait(750)
				cbr(userTable)
			end
		end
			search()
	else
		cbr()
	end
end

function findIfSteam(ids)
  local i = 0
  for l,w in pairs(ids) do
    if string.find(w, "steam:") ~= nil then
      return true
    end
  end
  Wait(100)
    return false
end


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


function vRP.getUserNames(usertable, cbr)
	local charnames = {{"Ikke Oprettet", 0}, {"Ikke Oprettet", 0}, {"Ikke Oprettet", 0}}
	local legal = 0
	for i=1, 3 do
		if usertable[i] ~= nil then
			charnames[i][2] = usertable[i].user_id
      MySQL.Async.fetchAll('SELECT firstname, name FROM vrp_user_identities WHERE user_id = @user_id', {user_id = usertable[i].user_id}, function(rows)
				if #rows > 0 then
					charnames[i][1] = rows[1].firstname .. " " .. rows[1].name	
				end	
			end)
		end
	end
	Wait(750)
	cbr(charnames)
end

-- return identification string for the source (used for non vRP identifications, for rejected players)
function vRP.getSourceIdKey(source)
  local ids = GetPlayerIdentifiers(source)
  local idk = "idk_"
  for k,v in pairs(ids) do
    idk = idk..v
  end

  return idk
end

function vRP.getPlayerEndpoint(player)
  return GetPlayerEP(player) or "0.0.0.0"
end

function vRP.getPlayerName(player)
  return GetPlayerName(player) or "unknown"
end

function vRP.isBanned(user_id, cbr)
  MySQL.Async.fetchAll('SELECT identifier FROM vrp_user_ids WHERE user_id = @user_id', {user_id = user_id}, function(rows)
      if #rows > 0 then
      MySQL.Async.fetchAll('SELECT user_id FROM vrp_user_ids WHERE identifier = @identifier', {identifier = rows[1].identifier}, function(rows1)
        if #rows1 > 0 then
            for i=1, #rows1 do
              MySQL.Async.fetchAll("SELECT banned FROM vrp_users WHERE id = @user_id", {user_id = rows1[i].user_id}, function(rows2)
                if #rows2 > 0 then
                    cbr(rows2[1].banned)
                end
                 end)
                 end
                 cbr(false)
              end
          end)
      end
  end)
end

--- sql
function vRP.setBanned(user_id, reason, banned)
  MySQL.Async.execute("UPDATE vrp_users SET banned = @banned, ban_reason = @ban_reason WHERE id = @user_id", {user_id = user_id, ban_reason = reason, banned = banned})
end

--- sql
function vRP.isWhitelisted(user_id, cbr)
  local task = Task(cbr, {false})

  MySQL.Async.fetchAll("SELECT whitelisted FROM vrp_users WHERE id = @user_id", {user_id = user_id}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].whitelisted})
    else
      task()
    end
  end)
end

--- sql
function vRP.setWhitelisted(user_id,whitelisted)
  MySQL.Async.execute("UPDATE vrp_users SET whitelisted = @whitelisted WHERE id = @user_id", {user_id = user_id, whitelisted = whitelisted})
end

--- sql
function vRP.getLastLogin(user_id, cbr)
  local task = Task(cbr,{""})
  MySQL.Async.fetchAll("SELECT last_login FROM vrp_users WHERE id = @user_id", {user_id = user_id}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].last_login})
    else
      task()
    end
  end)
end

function vRP.setUData(user_id,key,value)
  MySQL.Async.execute("REPLACE INTO vrp_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)", {user_id = user_id, key = key, value = value})
end

function vRP.getUData(user_id,key,cbr)
  local task = Task(cbr,{""})

  MySQL.Async.fetchAll("SELECT dvalue FROM vrp_user_data WHERE user_id = @user_id AND dkey = @key", {user_id = user_id, key = key}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].dvalue})
    else
      task()
    end
  end)
end

function vRP.setSData(key,value)
  MySQL.Async.execute("REPLACE INTO vrp_srv_data(dkey,dvalue) VALUES(@key,@value)", {key = key, value = value})
end

function vRP.getSData(key, cbr)
  local task = Task(cbr,{""})

  MySQL.Async.fetchAll("SELECT dvalue FROM vrp_srv_data WHERE dkey = @key", {key = key}, function(rows, affected)
    if #rows > 0 then
      task({rows[1].dvalue})
    else
      task()
    end
  end)
end

-- return user data table for vRP internal persistant connected user storage
function vRP.getUserDataTable(user_id)
  return vRP.user_tables[user_id]
end

function vRP.setUserDataTable(user_id, table)
  vRP.user_tables[user_id] = table
end

function vRP.getUserTmpTable(user_id)
  return vRP.user_tmp_tables[user_id]
end

function vRP.isConnected(user_id)
  return vRP.rusers[user_id] ~= nil
end

function vRP.isFirstSpawn(user_id)
  local tmp = vRP.getUserTmpTable(user_id)
  return tmp and tmp.spawns == 1
end

function vRP.getUserId(source)
  if source ~= nil then
    local ids = GetPlayerIdentifiers(source)
    if ids ~= nil and #ids > 0 then
      return vRP.users[ids[1]]
    end
  end

  return nil
end
-- DISCORD LOGS
function vRP.Webhook(webhook, text, boolean)
  if boolean == true then
    PerformHttpRequest(webhook, function(err, text, headers) 
    end, 'POST', json.encode({
        username = 'Urban | Logs', 
        content = ">>> "..text.." \n @here"
    }), { ['Content-Type'] = 'application/json' })
  elseif boolean == false then
  PerformHttpRequest(webhook, function(err, text, headers) 
      end, 'POST', json.encode({
          username = 'Urban | Logs', 
          content = ">>> "..text
      }), { ['Content-Type'] = 'application/json' })
    end
end
-- DISCORD ID
function vRP.setDiscord(source,user_id)
  local ids = GetPlayerIdentifiers(source)
  local discord = ""
  for k,v in pairs(ids) do
    if string.find(v, "discord:") ~= nil then
      discord = v:gsub("discord:","")
    end
  end
  if discord ~= "" then
    MySQL.Async.execute("UPDATE vrp_users SET discord=@discord WHERE id = @user_id", {user_id = user_id, discord = discord})
  end
end

-- return map of user_id -> player source
function vRP.getUsers()
  local users = {}
  for k,v in pairs(vRP.user_sources) do
    users[k] = v
  end

  return users
end

-- return source or nil
function vRP.getUserSource(user_id)
  return vRP.user_sources[user_id]
end

function vRP.ban(source,reason, isUser)
  local user_id = (isUser == false and vRP.getUserId(source) or source)
  if user_id ~= nil then
    vRP.setBanned(user_id,true,reason)
    source = (isUser == false and source or vRP.getUserSource(user_id))
    if source ~= nil then
      vRP.kick(source,"Udelukket med grunden: "..reason)
    end
  end
end

function vRP.unban(id,reason)
  vRP.setBanned(id,false,reason)
end

function vRP.kick(source,reason)
  DropPlayer(source,reason)
end

-- tasks

function task_save_datatables()
  TriggerEvent("vRP:save")

  Debug.pbegin("vRP save datatables")
  for k,v in pairs(vRP.user_tables) do
    vRP.setUData(k,"vRP:datatable",json.encode(v))
    Wait(100)
  end

  Debug.pend()
  SetTimeout(config.save_interval*1000, task_save_datatables)
end
task_save_datatables()

function tvRP.ping()
  local user_id = vRP.getUserId(source)
  if user_id ~= nil then
    local tmpdata = vRP.getUserTmpTable(user_id)
    tmpdata.pings = 0 -- reinit ping countdown
  end
end

AddEventHandler("playerDropped",function(reason)
  local source = source
  Debug.pbegin("playerDropped")
  local date = os.date("%H:%M:%S %d/%m/%Y")

  -- remove player from connected clients
  vRPclient.removePlayer(-1,{source})


  local user_id = vRP.getUserId(source)

  if user_id ~= nil then
    TriggerEvent("vRP:playerLeave", user_id, source)

    -- save user data table
    vRP.setUData(user_id,"vRP:datatable",json.encode(vRP.getUserDataTable(user_id)))

    vRP.Webhook('https://discord.com/api/webhooks/937817385103155310/qiRlBp85k35wdsOVSmnZUS5rmqqUvBHZDYeKv2PZOTzD4IfZdUXxjRKb5n7MKCEsGpY4', '__Spiller forlod serveren.__ \n **SPILLER ID:** ['..user_id..'] \n **DATO:** ['..date..'] \n **FORLOD MED GRUNDEN:** ['..reason..'] \n **MAIN SERVEREN**', false)
    vRP.Webhook('https://discord.com/api/webhooks/937817385103155310/qiRlBp85k35wdsOVSmnZUS5rmqqUvBHZDYeKv2PZOTzD4IfZdUXxjRKb5n7MKCEsGpY4', 'ID: '..user_id..' \n Info encoded: '..json.encode(vRP.getUserDataTable(user_id))..' \n Info: '..json.encode(vRP.getUserDataTable(user_id)), false)
    vRP.users[vRP.rusers[user_id]] = nil
    vRP.rusers[user_id] = nil
    vRP.user_tables[user_id] = nil
    vRP.user_tmp_tables[user_id] = nil
    vRP.user_sources[user_id] = nil
  end
  Debug.pend()
end)

RegisterServerEvent("vRPcli:playerSpawned")
AddEventHandler("vRPcli:playerSpawned", function()
  Debug.pbegin("playerSpawned")
  -- register user sources and then set first spawn to false
  local user_id = vRP.getUserId(source)
  local player = source
  if user_id ~= nil then
    vRP.user_sources[user_id] = source
    local tmp = vRP.getUserTmpTable(user_id)
    tmp.spawns = tmp.spawns+1
    local first_spawn = (tmp.spawns == 1)

    if first_spawn then
      -- first spawn, reference player
      -- send players to new player
      for k,v in pairs(vRP.user_sources) do
        vRPclient.addPlayer(source,{v})
      end
      -- send new player to all players
      vRPclient.addPlayer(-1,{source})
    end

    -- set client tunnel delay at first spawn
    Tunnel.setDestDelay(player, config.load_delay)

    -- show loading
    TriggerClientEvent("fnalte:joinserver", player)
    vRPclient.setProgressBar(player,{"vRP:loading", "botright", "Indlæser...", 0,0,0, 100})

    SetTimeout(2000, function() -- trigger spawn event
      SetTimeout(config.load_duration*1000, function() -- set client delay to normal delay
        Tunnel.setDestDelay(player, config.global_delay)
        vRPclient.removeProgressBar(player,{"vRP:loading"})
        TriggerEvent("vRP:playerSpawn",user_id,player,first_spawn)
      end)
    end)
  end


  Debug.pend()
end)

RegisterServerEvent("vRP:playerDied")



RegisterServerEvent("dylantic:joinserver")
AddEventHandler("dylantic:joinserver", function(charnames, nowUserId, source, name, ids, deferrals)
        deferrals.update("[Urban] | Tjekker om du er udelukket...")
        vRP.isBanned(nowUserId, function(banned)
          if not banned then
            deferrals.update("[Urban] | Tjekker om du er allowlisted...")
            vRP.isWhitelisted(nowUserId, function(whitelisted)
              if not config.whitelist or whitelisted then
                Debug.pbegin("playerConnecting_delayed")
                if vRP.rusers[nowUserId] == nil then -- not present on the server, init
                  -- init entries
                  vRP.users[ids[1]] = nowUserId
                  vRP.rusers[nowUserId] = ids[1]
                  vRP.user_tables[nowUserId] = {}
                  vRP.user_tmp_tables[nowUserId] = {}
                  vRP.user_sources[nowUserId] = source

                  -- load user data table
                  deferrals.update("[Urban] | Indlæser datatables...")
                  vRP.getUData(nowUserId, "vRP:datatable", function(sdata)
                    local data = json.decode(sdata)
                    if type(data) == "table" then vRP.user_tables[nowUserId] = data end

                    -- init user tmp table
                    local tmpdata = vRP.getUserTmpTable(nowUserId)

                    deferrals.update("[Urban] | Henter tidligere login...")
                    vRP.getLastLogin(nowUserId, function(last_login)
                      tmpdata.last_login = last_login or ""
                      tmpdata.spawns = 0

                      -- set last login
                      local ep = vRP.getPlayerEndpoint(source)
                      local last_login_stamp = ep
                      local last_login_date = os.date("%H:%M:%S %d/%m/%Y")
                      MySQL.Async.execute("UPDATE vrp_users SET last_login = @last_login, last_date = @last_date WHERE id = @user_id", {user_id = nowUserId, last_login = last_login_stamp, last_date = last_login_date})

                      -- trigger join
                      vRP.Webhook('https://discord.com/api/webhooks/937817385103155310/qiRlBp85k35wdsOVSmnZUS5rmqqUvBHZDYeKv2PZOTzD4IfZdUXxjRKb5n7MKCEsGpY4', '__Spiller joinede serveren.__ \n **SPILLER ID:** ['..nowUserId..'] \n **DATO:** ['..last_login_date..'] \n **MAIN SERVEREN**', false)
                      TriggerEvent("vRP:playerJoin", nowUserId, source, name, tmpdata.last_login)
                      vRP.setDiscord(source,nowUserId)
                      deferrals.done()
                    end)
                  end)
                else -- already connected
																													 
																																																																																										 
                  TriggerEvent("vRP:playerRejoin", nowUserId, source, name)
                  deferrals.done()

                  -- reset first spawn
                  local tmpdata = vRP.getUserTmpTable(nowUserId)
                  tmpdata.spawns = 0
                end

                Debug.pend()
              else
                local last_login_date = os.date("%H:%M:%S %d/%m/%Y")
                deferrals.done("[Urban] | Du er ikke allowlisted | Dit id: "..nowUserId.." | Ansøg om allowlist på vores discord: https://discord.gg/quMHerfjas")
                vRP.Webhook('https://discord.com/api/webhooks/937817385103155310/qiRlBp85k35wdsOVSmnZUS5rmqqUvBHZDYeKv2PZOTzD4IfZdUXxjRKb5n7MKCEsGpY4', '__Spiller joinede serveren uden allowlist.__ \n **SPILLER ID:** ['..nowUserId..'] \n **IP:** ['..playerip..'] \n **DATO:** ['..last_login_date..'] \n **MAIN SERVEREN**', false)
              end
            end)
          else
            deferrals.done("Du har ikke adgang, Kontakt staff på discorden ("..nowUserId..")")
            end
  Debug.pend()
  end)
end)



function vRP.setUserId(source, nowUserId, name)
    local ids = GetPlayerIdentifiers(source)
    if ids ~= nil and #ids > 0 then
      vRP.getUserIdByIdentifiers(ids, function(user_ids)
        local nowUserId = nowUserId
        local user_id = vRP.getUserId(source)
        if user_id ~= nil then
          vRP.setUData(user_id,"vRP:datatable",json.encode(vRP.getUserDataTable(user_id)))

          vRP.users[vRP.rusers[user_id]] = nil
          vRP.rusers[user_id] = nil
          vRP.user_tables[user_id] = nil
          vRP.user_tmp_tables[user_id] = nil
          vRP.user_sources[user_id] = nil



          if vRP.rusers[nowUserId] == nil then 
              vRP.users[ids[1]] = nowUserId
              vRP.rusers[nowUserId] = ids[1]
              vRP.user_tables[nowUserId] = {}
              vRP.user_tmp_tables[nowUserId] = {}
              vRP.user_sources[nowUserId] = source

              vRP.getUData(nowUserId, "vRP:datatable", function(sdata)
                  local data = json.decode(sdata)
                  if type(data) == "table" then 
                      vRP.user_tables[nowUserId] = data 
                  end
                  local tmpdata = vRP.getUserTmpTable(nowUserId)
                  vRP.getLastLogin(nowUserId, function(last_login)
                    tmpdata.last_login = last_login or ""
                    tmpdata.spawns = 1
                    local ep = vRP.getPlayerEndpoint(source)
                    local last_login_stamp = ep
                    local last_login_date = os.date("%H:%M:%S %d/%m/%Y")
                    MySQL.Async.execute("UPDATE vrp_users SET last_login = @last_login, last_date = @last_date WHERE id = @user_id", {user_id = nowUserId, last_login = last_login_stamp, last_date = last_login_date})
                    TriggerEvent("vRP:playerJoin", nowUserId, source, name, tmpdata.last_login)
                  end)
              end)
          end
        end
      end)
    end
end

AddEventHandler(
    "playerConnecting",
    function(name, setMessage, deferrals)
        deferrals.defer()
        local chars = {"Ikke Oprettet", "Ikke Oprettet", "Ikke Oprettet"}
        local source = source
        Debug.pbegin("playerConnecting")
        local ids = GetPlayerIdentifiers(source)

        if ids ~= nil and #ids > 0 then
          deferrals.update("[Urban] | Tjekker din identitet (Husk at åben steam)...")
          vRP.getUserIdByIdentifiers(ids,function(user_id)
                  Wait(1250)
                  if user_id ~= false then -- check user validity
                      vRP.getUserNames(user_id,function(charnames)
                              for i = 1, 3 do
                                vRP.isWhitelisted(charnames[i][2],function(whitelisted)
                                        if whitelisted then
                                            whitelisted = "Ja"
                                        else
                                            whitelisted = "Nej"
                                        end
                                    end)
                              end
                              local num = GetNumPlayerIndices()
                              local nowUserId = tonumber(charnames[1][2])
                              deferrals.update("[Urban] Tjekker om du er banned...")
                              vRP.isBanned(nowUserId,function(banned)
                                      if not banned then
                                          deferrals.update("[Urban] | Tjekker om du er allowlisted...")
                                          vRP.isWhitelisted(nowUserId,function(whitelisted)
                                              if not config.whitelist or whitelisted then
                                                  MySQL.Async.fetchAll(
                                                      "SELECT * FROM vrp_user_identities WHERE user_id = @user_id",
                                                      {
                                                          ["@user_id"] = nowUserId
                                                      },
                                                      function(result)
                                                          if #result == 0 then
                                                              MySQL.Async.execute(
                                                                  "INSERT IGNORE INTO vrp_user_identities (user_id, firstname, name, sex, height, age) VALUES(@user_id,@firstname, @name, @sex, @height, @age)",
                                                                  {
                                                                      ["@user_id"] = charnames[1][2],
                                                                      ["@firstname"] = "Skift",
                                                                      ["@name"] = "Navn",
                                                                      ["@height"] = "180",
                                                                      ["@age"] = 20,
                                                                      ["@sex"] = "Mand"
                                                                  }
                                                              )
                                                              MySQL.Async.execute(
                                                                  "INSERT IGNORE INTO vrp_user_identities (user_id, firstname, name, sex, height, age) VALUES(@user_id,@firstname, @name, @sex, @height, @age)",
                                                                  {
                                                                      ["@user_id"] = charnames[2][2],
                                                                      ["@firstname"] = "Skift",
                                                                      ["@name"] = "Navn",
                                                                      ["@height"] = "180",
                                                                      ["@age"] = 20,
                                                                      ["@sex"] = "Mand"
                                                                  }
                                                              )
                                                              MySQL.Async.execute(
                                                                  "INSERT IGNORE INTO vrp_user_identities (user_id, firstname, name, sex, height, age) VALUES(@user_id,@firstname, @name, @sex, @height, @age)",
                                                                  {
                                                                      ["@user_id"] = charnames[3][2],
                                                                      ["@firstname"] = "Skift",
                                                                      ["@name"] = "Navn",
                                                                      ["@height"] = "180",
                                                                      ["@age"] = 20,
                                                                      ["@sex"] = "Mand"
                                                                  }
                                                              )
                                                              TriggerEvent("dylantic-giveCPR", charnames[1][2], 20)
                                                              TriggerEvent("dylantic-giveCPR", charnames[2][2], 20)
                                                              TriggerEvent("dylantic-giveCPR", charnames[3][2], 20)
                                                              vRP.setDiscord(source,charnames[1][2])
                                                              vRP.setDiscord(source,charnames[2][2])
                                                              vRP.setDiscord(source,charnames[3][2])
                                                          else
                                                              TriggerEvent("dylantic:joinserver",charnames,nowUserId,source,name,ids,deferrals)
                                                          end
                                                      end)
                                              else
                                                  deferrals.done("[Urban] | Du er ikke allowlisted | Dit id: " ..nowUserId.." | Ansøg om allowlist på vores discord: https://discord.gg/quMHerfjas")
                                              end
                                          end)
                                      else
                                      MySQL.Async.fetchAll(
                                          "SELECT * FROM vrp_users WHERE id = @id",
                                          {
                                              ["@id"] = nowUserId
                                          },
                                          function(result)
                                              local DylanticCheck = result
                                              deferrals.done("[Urban] | Du er udelukket | Dit id: "..nowUserId .." | Ansøg om unban på vores discord: https://discord.gg/quMHerfjas")
                                              Debug.pend()
                                          end)
                                      end
                                  end)
                          end)
                  end
              end)
        else
            deferrals.done("[Urban] Tjek om du har dit steam åben og ellers prøv at genstarte det.")
        end
    end)



