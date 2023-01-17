--[[

███╗░░░███╗░█████╗░██████╗░███████╗  ██████╗░██╗░░░██╗  ███████╗███╗░░██╗░█████╗░██╗░░░░░████████╗███████╗
████╗░████║██╔══██╗██╔══██╗██╔════╝  ██╔══██╗╚██╗░██╔╝  ██╔════╝████╗░██║██╔══██╗██║░░░░░╚══██╔══╝██╔════╝
██╔████╔██║███████║██║░░██║█████╗░░  ██████╦╝░╚████╔╝░  █████╗░░██╔██╗██║███████║██║░░░░░░░░██║░░░█████╗░░
██║╚██╔╝██║██╔══██║██║░░██║██╔══╝░░  ██╔══██╗░░╚██╔╝░░  ██╔══╝░░██║╚████║██╔══██║██║░░░░░░░░██║░░░██╔══╝░░
██║░╚═╝░██║██║░░██║██████╔╝███████╗  ██████╦╝░░░██║░░░  ██║░░░░░██║░╚███║██║░░██║███████╗░░░██║░░░███████╗
╚═╝░░░░░╚═╝╚═╝░░╚═╝╚═════╝░╚══════╝  ╚═════╝░░░░╚═╝░░░  ╚═╝░░░░░╚═╝░░╚══╝╚═╝░░╚═╝╚══════╝░░░╚═╝░░░╚══════╝
--]]
-------------------------------------------------------------
--                         HT_BASE                         --
-------------------------------------------------------------
HT = nil

Citizen.CreateThread(function()
    while HT == nil do
        TriggerEvent('HT_base:getBaseObjects', function(obj) HT = obj end)
        Citizen.Wait(0)
    end
end)

-------------------------------------------------------------
--                         Open Menu                       --
--------------------------------------------------------------
Citizen.CreateThread(function()
	while Config.Marker do
	  Citizen.Wait(0)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		for _, item in pairs(Config.Locations) do
		if(Vdist(pos.x, pos.y, pos.z, item.x, item.y, item.z+1) < 5.0)then
		DrawMarker(20, item.x, item.y, item.z+1, 0, 0, 0, 0, 0, 0, 0.301, 0.3001, 0.3001, 243, 186, 87, 200, 1, 0, 0, 1)
		if(Vdist(pos.x, pos.y, pos.z, item.x, item.y, item.z+1) < 15.0)then
			DrawText3Ds(item.x, item.y, item.z+1.50, "E for at åbne menuen")
			if IsControlJustPressed(0, Config.OpenMenu) then
				HT.TriggerServerCallback("PoliceMenu:Permission", function(cb)
					if cb then
						PoliceMenu()
					end
				end)
			end
		  end
		end
	  end
	end
  end)


Citizen.CreateThread(function()
	while Config.HotKey do
		Citizen.Wait(0)
		if IsControlJustPressed(0, Config.OpenHotKey) then
			HT.TriggerServerCallback("PoliceMenu:Permission", function(cb)
				if cb then
					PoliceMenu()
				end
			end)
		end
	end
end)
-------------------------------------------------------------
--                         Menu		                       --
-------------------------------------------------------------
  function PoliceMenu()
	local player = PlayerPedId()
	local elements = {}
			
	for k,v in pairs(Config.Options) do
		if v.Enabled == true then
			table.insert(elements,{label = v.label .. "", value = v.mulighed, Enabled = v.Enabled,})
		end
	end
	table.insert(elements,{label = "Luk Menu", value = "cancel_police_menu"})
		
	HT.UI.Menu.Open('default', GetCurrentResourceName(), "choose_police_menu",
		{
			title    = "Politi Menu",
			align    = "center",
			elements = elements
		},
	function(data, menu)
			if data.current.value == "cancel_police_menu" then
				menu.close()
			elseif data.current.value == "account" then
				Moneymenu()
				Citizen.Wait(100)
				menu.close()
			elseif data.current.value == "hire_cop" then 
				EmployeeMenu()
			elseif data.current.value == "jail_menu" then 
				Jailmenu()
			elseif data.current.value == "cuff" then 
				TriggerServerEvent("WuPolice:Cuff")
			elseif data.current.value == "fine" then 
				TriggerServerEvent("WuPolice:Fine")
			end
			
	end, function(data, menu)
		menu.close()
	end, function(data, menu)
	end)
end
-------------------------------------------------------------
--                         Money Menu	                   --
-------------------------------------------------------------
function Moneymenu()
	HT.TriggerServerCallback("SkovsOgwuErEnOstemiss", function(cb)
		local elements = {
			{ label = "Indsæt Penge", value = "account_deposit" },
			{ label = "Hæv Penge", value = "account_withdraw" },
		}
		HT.UI.Menu.Open('default', GetCurrentResourceName(), "account",
			{
				title    = "Konto Penge: ".. cb[1].amount .."",
				align    = "center",
				elements = elements
			},
		function(data, menu)
			if(data.current.value == 'account_deposit') then
				menu.close()
				HT.UI.Menu.Open('dialog', GetCurrentResourceName(), 'account_deposit', {
					title = "Hvor meget vil du indsætte?"
				}, function(data2, menu2)
					local money = tonumber(data2.value)
					TriggerServerEvent("GiveMoney", money)
					menu2.close()
				end,
				function(data2, menu2)
					menu2.close()	
				end)
			end
			if(data.current.value == 'account_withdraw') then
				menu.close()
				HT.UI.Menu.Open('dialog', GetCurrentResourceName(), 'account_withdraw', {
					title = "Konto Penge: ".. cb[1].amount .."",
				}, function(data2, menu2)
					menu2.close()
					local getmoney = tonumber(data2.value)
					TriggerServerEvent("GetMoney", getmoney)
				end,
				function(data2, menu2)
					menu2.close()	
				end)
			end
			menu.close()
		end, function(data, menu)
			menu.close()
		end)
	end)
end
-------------------------------------------------------------
--                       Employee Menu	                   --
-------------------------------------------------------------
function EmployeeMenu()
	local elements = {
		{ label = "Ansæt Medarbejder", value = "hire_menu_cop" },
		{ label = "Fyr Medarbejder", value = "fire_menu_cop" },
	}
	HT.UI.Menu.Open('default', GetCurrentResourceName(), "hire_menu",
		{
			title    = "Medarbejder Menu",
			align    = "center",
			elements = elements
		},
	function(data, menu)
		if(data.current.value == 'hire_menu_cop') then
			menu.close()
			HT.UI.Menu.Open('dialog', GetCurrentResourceName(), 'hire_menu_cop', {
				title = "Skriv ID på den nye betjent"
			}, function(data2, menu2)
				menu2.close()
				local nuser_id = tonumber(data2.value)
				TriggerServerEvent('PoliceMenu:GiveJob',nuser_id)
			end,
			function(data2, menu2)
				menu2.close()	
				EmployeeMenu()
			end)
		end
		if(data.current.value == 'fire_menu_cop') then
			menu.close()
			HT.UI.Menu.Open('dialog', GetCurrentResourceName(), 'fire_menu_cop', {
				title = "Skriv ID på den betjent du vil fyre"
			}, function(data2, menu2)
				menu2.close()
				local nuser_id = tonumber(data2.value)
				TriggerServerEvent('PoliceMenu:RemoveJob',nuser_id)
			end,
			function(data2, menu2)
				menu2.close()	
			end)
		end
		menu.close()
	end, function(data, menu)
		menu.close()
	end)
end
-------------------------------------------------------------
--                      Jail/Unjail Menu		           --
-------------------------------------------------------------
function Jailmenu()
	local elements = {
		{ label = "Sæt spiller i fængsel", value = "jail_player" },
		{ label = "Løslad Spiller", value = "unjail_player" },
	}
	HT.UI.Menu.Open('default', GetCurrentResourceName(), "jail_player",
		{
			title    = "Jail Spiller",
			align    = "center",
			elements = elements
		},
	function(data, menu)
		if(data.current.value == 'jail_player') then
			TriggerServerEvent("JailPlayer")
			menu.close()
		end
		if(data.current.value == 'unjail_player') then
			TriggerServerEvent("unJailPlayer")
			menu.close()
		end
	end, function(data, menu)
		menu.close()
	end)
end

-- Cloth to jailed player
RegisterNetEvent('wu:jailcloth')
AddEventHandler('wu:jailcloth', function()
ped = GetPlayerPed(-1)
	if GetEntityModel(ped) == GetHashKey("mp_m_freemode_01") then 
		SetPedComponentVariation(ped, 4, 9, 4, 0) -- Bukser
		SetPedComponentVariation(ped, 1, 0, 0, 0) -- Maske
		SetPedComponentVariation(ped, 11, 237, 0, 0) -- Jakke
		SetPedComponentVariation(ped, 8, 15, 0, 0) -- Tshirt
		SetPedComponentVariation(ped, 3, 5, 0, 0) -- krop
	end
end)
-------------------------------------------------------------
--                         Functions                       --
-------------------------------------------------------------
function DrawText3Ds(x,y,z, text)
local onScreen,_x,_y=World3dToScreen2d(x,y,z)
local px,py,pz=table.unpack(GetGameplayCamCoords())
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end
	
