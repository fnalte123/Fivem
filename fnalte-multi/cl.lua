--[[

███╗░░░███╗░█████╗░██████╗░███████╗  ██████╗░██╗░░░██╗  ███████╗███╗░░██╗░█████╗░██╗░░░░░████████╗███████╗
████╗░████║██╔══██╗██╔══██╗██╔════╝  ██╔══██╗╚██╗░██╔╝  ██╔════╝████╗░██║██╔══██╗██║░░░░░╚══██╔══╝██╔════╝
██╔████╔██║███████║██║░░██║█████╗░░  ██████╦╝░╚████╔╝░  █████╗░░██╔██╗██║███████║██║░░░░░░░░██║░░░█████╗░░
██║╚██╔╝██║██╔══██║██║░░██║██╔══╝░░  ██╔══██╗░░╚██╔╝░░  ██╔══╝░░██║╚████║██╔══██║██║░░░░░░░░██║░░░██╔══╝░░
██║░╚═╝░██║██║░░██║██████╔╝███████╗  ██████╦╝░░░██║░░░  ██║░░░░░██║░╚███║██║░░██║███████╗░░░██║░░░███████╗
╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═════╝░╚══════╝  ╚═════╝░░░░╚═╝░░░  ╚═╝░░░░░╚═╝░░╚══╝╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚══════╝
--]]

HT = nil
open = false
first = true

Citizen.CreateThread(function()

    while HT == nil do
        TriggerEvent('HT_base:getBaseObjects', function(obj) HT = obj end)
        Citizen.Wait(0)
    end
end)


RegisterCommand("test", function()
first = true 
TriggerEvent("fnalte:joinserver")

end)

RegisterNetEvent('fnalte:joinserver')
AddEventHandler('fnalte:joinserver', function()
    if first then 
        FreezeEntityPosition(GetPlayerPed(-1), true)
        SetPlayerInvincible(GetPlayerIndex(),true)
        local interior = GetInteriorAtCoords(-763.56231689453,325.54333496094,170.59649658203 - 18.9)
        LoadInterior(interior)
        SpawnPEDS()
        first = false
    end
end)

function SetCam(bool)
    local ply = GetPlayerPed(-1)
    FreezeEntityPosition(ply, true)
    DisplayRadar(false, false)
    SetEntityVisible(ply, false, false)
    if bool then
        FreezeEntityPosition(PlayerPedId(), true)
        cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", -763.56231689453,325.54333496094,170.59649658203, 0.0 ,0.00, 267.00, 60.00, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, false, 1, true, true)
    else
        DoScreenFadeOut(20)
        TriggerEvent('raid_clothes:LoadYourClothes')
        ClearFocus()
        SetCamActive(cam, false)
        DestroyCam(cam, true)
        RenderScriptCams(false, false, 1, true, true)
        FreezeEntityPosition(PlayerPedId(), false)
        SetEntityVisible(ply, true, true)
        SetPlayerInvincible(GetPlayerIndex(),false)
        DisplayRadar(true, true)
        Wait(2000)
        DoScreenFadeIn(2000)
    end
end


function SpawnPEDS()
    SetCam(true)
    selection = 1
    delay = 500
    spawned = true 
    HT.TriggerServerCallback("fnalte:GetUserIds", function(users)
        HT.TriggerServerCallback("fnalte:getPlayerSkin", function(data)
            HT.TriggerServerCallback("fnalte:GetuserNames", function(id1, id2, id3)
                local lmodel = data.model or GetHashKey(data.model)
                RequestModel(lmodel)
                while not HasModelLoaded(lmodel) do
                    Wait(10)
                end
                local ply = GetPlayerPed(-1)
                ply1 = CreatePed(4, lmodel, Config.PED1.x, Config.PED1.y, Config.PED1.z, Config.PED1.h, false, false)
                ply2 = CreatePed(4, lmodel, Config.PED2.x, Config.PED2.y, Config.PED2.z, Config.PED2.h, false, false)
                ply3 = CreatePed(4, lmodel, Config.PED3.x, Config.PED3.y, Config.PED3.z, Config.PED3.h, false, false) 
                SetEntityAlwaysPrerender(ply1, true)
                SetEntityAlwaysPrerender(ply2, true)
                SetEntityAlwaysPrerender(ply3, true)
                SetFocusPosAndVel(Config.PED1.x, Config.PED1.y, Config.PED1.z)

                for k,v in pairs(users) do
                    user1 = v.user1
                    user2 = v.user2
                    user3 = v.user3
                end
                TriggerServerEvent("fnaltemulti:loadclothes", ply1, user1)
                TriggerServerEvent("fnaltemulti:loadclothes", ply2, user2)
                TriggerServerEvent("fnaltemulti:loadclothes", ply3, user3)
                if ply > 0 and ply2 >0 and ply3 > 0 then 
                Wait(3000)
                SetEntityInvincible(ply1, true)
                FreezeEntityPosition(ply1, true)
                SetBlockingOfNonTemporaryEvents(ply1, true)
                if id1 == "newply" then
                    SetEntityAlpha(ply1, 100)
                end


                local selAnim = math.random(1, #Anims)
                while beforeAnim and beforeAnim == selAnim do
                    Wait(0)
                    math.randomseed(GetGameTimer())
                    selAnim = math.random(1, #Anims)
                end
                beforeAnim = selAnim
                LoadAnim(Anims[selAnim].dict)
                TaskPlayAnim(ply1, Anims[selAnim].dict, Anims[selAnim].name, 8.0, 8.0, -1, 1, 0.0, 0, 0, 0)


                SetEntityInvincible(ply2, true)
                FreezeEntityPosition(ply2, true)
                SetBlockingOfNonTemporaryEvents(ply2, true)
                if id2 == "newply" then
                    SetEntityAlpha(ply2, 100)
                end

                local selAnim = math.random(1, #Anims)
                while beforeAnim and beforeAnim == selAnim do
                    Wait(0)
                    math.randomseed(GetGameTimer())
                    selAnim = math.random(1, #Anims)
                end
                beforeAnim = selAnim
                LoadAnim(Anims[selAnim].dict)
                TaskPlayAnim(ply2, Anims[selAnim].dict, Anims[selAnim].name, 8.0, 8.0, -1, 1, 0.0, 0, 0, 0)


                SetEntityInvincible(ply3, true)
                FreezeEntityPosition(ply3, true)
                SetBlockingOfNonTemporaryEvents(ply3, true)
                if id3 == "newply" then
                    SetEntityAlpha(ply3, 100)
                end

                local selAnim = math.random(1, #Anims)
                while beforeAnim and beforeAnim == selAnim do
                    Wait(0)
                    math.randomseed(GetGameTimer())
                    selAnim = math.random(1, #Anims)
                end
                beforeAnim = selAnim
                LoadAnim(Anims[selAnim].dict)
                TaskPlayAnim(ply3, Anims[selAnim].dict, Anims[selAnim].name, 8.0, 8.0, -1, 1, 0.0, 0, 0, 0)

                while spawned do
                    delay = 1
                    Wait(delay)
                    if IsControlJustPressed(0,307) and selection ~= 3 then 
                        selection = selection +1
                        if selection == 1 then
                            TriggerEvent("skovsboell:refreshUI",user1)
                        elseif selection == 2 then
                            TriggerEvent("skovsboell:refreshUI",user2)
                        else
                            TriggerEvent("skovsboell:refreshUI",user3)
                        end
                    elseif IsControlJustPressed(0,308) and selection ~= 1 then
                        selection = selection -1
                        if selection == 1 then
                            TriggerEvent("skovsboell:refreshUI",user1)
                        elseif selection == 2 then
                            TriggerEvent("skovsboell:refreshUI",user2)
                        else
                            TriggerEvent("skovsboell:refreshUI",user3)
                        end
                    end
                        if selection == 1 then
                            DrawMarker(20, Config.PED1.x, Config.PED1.y, Config.PED1.z+1,0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.35, 0.35, 0.35, 25, 141, 250, 100, false, true, 2, false, false, false, false)
                        elseif selection == 2 then 
                            DrawMarker(20, Config.PED2.x, Config.PED2.y, Config.PED2.z+1,0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.35, 0.35, 0.35, 25, 141, 250, 100, false, true, 2, false, false, false, false)
                        elseif selection == 3 then
                            DrawMarker(20, Config.PED3.x, Config.PED3.y, Config.PED3.z+1,0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.35, 0.35, 0.35, 25, 141, 250, 100, false, true, 2, false, false, false, false)
                        end
                        
                        if IsControlJustPressed(0, 18) then 
                            if selection == 1 then
                                Char = user1
                                identification =  id1
                            elseif selection == 2 then
                                Char = user2
                                identification = id2
                            else
                                Char = user3
                                identification = id3
                            end
                            DoScreenFadeOut(2000)
                            TriggerServerEvent("fnalte:SetId", Char, identification)
                            HT.TriggerServerCallback("fnalte:GetPosition", function(pos, startpos)
                                if pos ~= nil then 
                                    SetEntityCoords(ply, pos.position.x,pos.position.y,pos.position.z)
                                else
                                    SetEntityCoords(GetPlayerPed(-1), startpos[1],startpos[2],startpos[3])
                                end
                                DeleteEntity(ply1)
                                DeleteEntity(ply2)
                                DeleteEntity(ply3)
                                spawned = false
                                SetCam(false)
                            end, Char)
                        end
                    end
                end
                delay = 500
            end, users)
        end, users)
    end)
end


function LoadAnim(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
         Wait(100)
    end
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
  
  