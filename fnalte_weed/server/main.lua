--[[
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
─██████──────────██████─██████──██████────██████████████─██████████████─████████████████───██████████─██████████████─██████████████─██████████████─
─██░░██──────────██░░██─██░░██──██░░██────██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░░░██───██░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─
─██░░██──────────██░░██─██░░██──██░░██────██░░██████████─██░░██████████─██░░████████░░██───████░░████─██░░██████░░██─██████░░██████─██░░██████████─
─██░░██──────────██░░██─██░░██──██░░██────██░░██─────────██░░██─────────██░░██────██░░██─────██░░██───██░░██──██░░██─────██░░██─────██░░██─────────
─██░░██──██████──██░░██─██░░██──██░░██────██░░██████████─██░░██─────────██░░████████░░██─────██░░██───██░░██████░░██─────██░░██─────██░░██████████─
─██░░██──██░░██──██░░██─██░░██──██░░██────██░░░░░░░░░░██─██░░██─────────██░░░░░░░░░░░░██─────██░░██───██░░░░░░░░░░██─────██░░██─────██░░░░░░░░░░██─
─██░░██──██░░██──██░░██─██░░██──██░░██────██████████░░██─██░░██─────────██░░██████░░████─────██░░██───██░░██████████─────██░░██─────██████████░░██─
─██░░██████░░██████░░██─██░░██──██░░██────────────██░░██─██░░██─────────██░░██──██░░██───────██░░██───██░░██─────────────██░░██─────────────██░░██─
─██░░░░░░░░░░░░░░░░░░██─██░░██████░░██────██████████░░██─██░░██████████─██░░██──██░░██████─████░░████─██░░██─────────────██░░██─────██████████░░██─
─██░░██████░░██████░░██─██░░░░░░░░░░██────██░░░░░░░░░░██─██░░░░░░░░░░██─██░░██──██░░░░░░██─██░░░░░░██─██░░██─────────────██░░██─────██░░░░░░░░░░██─
─██████──██████──██████─██████████████────██████████████─██████████████─██████──██████████─██████████─██████─────────────██████─────██████████████─
───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
--]]
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","wu_weed") 

local PlantsLoaded = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000)
        if PlantsLoaded then
            TriggerClientEvent('wu_weed:client:updateWeedData', -1, Config.Plants)
        end
    end
end)

Citizen.CreateThread(function()
    TriggerEvent('wu_weed:server:getWeedPlants')
    print('wu_weed - #ALLE PLANTER LOADED!')
    PlantsLoaded = true
end)


RegisterServerEvent("wu_weed:kushseed")
AddEventHandler("wu_weed:kushseed", function()
    local src = source
    local user_id = vRP.getUserId({src})

    TriggerClientEvent('wu_weed:client:plantNewSeed', src, 'og_kush')
    vRP.tryGetInventoryItem({user_id, Config.WeedPlants.SeedOne.Spawn, 1})
end)

--[[vRP.defInventoryItem({Config.WeedPlants.SeedOne.Spawn, Config.WeedPlants.SeedOne.Label, Config.WeedPlants.SeedOne.Description, function(args)
    local choices = {}

    choices[Config.WeedPlants.SeedOne.Choice] = { function (source, choice)
    local src = source
    local user_id = vRP.getUserId({src})

    TriggerClientEvent('wu_weed:client:plantNewSeed', src, 'og_kush')
    vRP.tryGetInventoryItem({user_id, Config.WeedPlants.SeedOne.Spawn, 1})
	end}
return choices
end, 1.5})--]]

vRP.defInventoryItem({Config.WeedPlants.SeedTwo.Spawn, Config.WeedPlants.SeedTwo.Label, Config.WeedPlants.SeedTwo.Description, function(args)
    local choices = {}

    choices[Config.WeedPlants.SeedTwo.Choice] = { function (source, choice)
    local src = source
    local user_id = vRP.getUserId({src})

    TriggerClientEvent('wu_weed:client:plantNewSeed', src, 'banana_kush')
    vRP.tryGetInventoryItem({user_id, Config.WeedPlants.SeedTwo.Spawn, 1})
	end}
return choices
end, 1.5})

vRP.defInventoryItem({Config.WeedPlants.SeedThree.Spawn, Config.WeedPlants.SeedThree.Label, Config.WeedPlants.SeedThree.Description, function(args)
    local choices = {}

    choices[Config.WeedPlants.SeedThree.Choice] = { function (source, choice)
    local src = source
    local user_id = vRP.getUserId({src})

    TriggerClientEvent('wu_weed:client:plantNewSeed', src, 'blue_dream')
    vRP.tryGetInventoryItem({user_id, Config.WeedPlants.SeedThree.Spawn, 1})
	end}
return choices
end, 1.5})

vRP.defInventoryItem({Config.WeedPlants.SeedFour.Spawn, Config.WeedPlants.SeedFour.Label, Config.WeedPlants.SeedFour.Description, function(args)
    local choices = {}

    choices[Config.WeedPlants.SeedFour.Choice] = { function (source, choice)
    local src = source
    local user_id = vRP.getUserId({src})

    TriggerClientEvent('wu_weed:client:plantNewSeed', src, 'purplehaze')
    vRP.tryGetInventoryItem({user_id, Config.WeedPlants.SeedFour.Spawn, 1})
	end}
return choices
end, 1.5})

RegisterServerEvent('wu_weed:server:saveWeedPlant')
AddEventHandler('wu_weed:server:saveWeedPlant', function(data)
    local data = json.encode(data)
    
    MySQL.Async.execute('INSERT INTO weed_plants (properties) VALUES (@properties)', {
        ['@properties'] = data,
    }, function ()
    end)
end)

RegisterServerEvent('wu_weed:checkPlayerHasThisItem')
AddEventHandler('wu_weed:checkPlayerHasThisItem', function(item, cb)
    local src = source
    local user_id = vRP.getUserId({src})

    if vRP.getInventoryItemAmount({user_id, item}) > 0 then
        TriggerClientEvent(cb, src)
    else
        TriggerClientEvent('wu_weed:client:notify', src, Config.Notifications.Missing.. ' '..item)
    end
end)

RegisterServerEvent('wu_weed:server:giveShittySeed')
AddEventHandler('wu_weed:server:giveShittySeed', function()
    local src = source
    local user_id = vRP.getUserId({src})
    vRP.giveInventoryItem({user_id, Config.BadSeedReward, math.random(1, 2)})
end)

RegisterServerEvent('wu_weed:server:plantNewSeed')
AddEventHandler('wu_weed:server:plantNewSeed', function(type, location)
    local src = source
    local plantId = math.random(111111, 999999)
    local user_id = vRP.getUserId({src})
    local SeedData = {id = plantId, type = type, x = location.x, y = location.y, z = location.z, hunger = Config.StartingHunger, thirst = Config.StartingThirst, growth = 0.0, quality = 100.0, stage = 1, grace = true, beingHarvested = false, planter = user_id}

    local PlantCount = 0

    for k, v in pairs(Config.Plants) do
        if v.planter == user_id then
            PlantCount = PlantCount + 1
        end
    end

    if PlantCount >= Config.MaxPlantCount then
        TriggerClientEvent('wu_weed:client:notify', src, Config.Notifications.MaxPlantCount)
    else
        table.insert(Config.Plants, SeedData)
        TriggerClientEvent('wu_weed:client:plantSeedConfirm', src)
        TriggerEvent('wu_weed:server:saveWeedPlant', SeedData)
        TriggerEvent('wu_weed:server:updatePlants')
    end
end)

RegisterServerEvent('wu_weed:plantHasBeenHarvested')
AddEventHandler('wu_weed:plantHasBeenHarvested', function(plantId)
    for k, v in pairs(Config.Plants) do
        if v.id == plantId then
            v.beingHarvested = true
        end
    end

    TriggerEvent('wu_weed:server:updatePlants')
end)

RegisterServerEvent('wu_weed:destroyPlant')
AddEventHandler('wu_weed:destroyPlant', function(plantId)
    local src = source
    local user_id = vRP.getUserId({src})

    for k, v in pairs(Config.Plants) do
        if v.id == plantId then
            table.remove(Config.Plants, k)
        end
    end

    TriggerClientEvent('wu_weed:client:removeWeedObject', -1, plantId)
    TriggerEvent('wu_weed:server:weedPlantRemoved', plantId)
    TriggerEvent('wu_weed:server:updatePlants')
    TriggerClientEvent('wu_weed:client:notify', src, 'Du fjernede planten')
end)

RegisterServerEvent('wu_weed:harvestWeed')
AddEventHandler('wu_weed:harvestWeed', function(plantId)
    local src = source
    local user_id = vRP.getUserId({src})
    local amount
    local label
    local item
    local goodQuality = false
    local hasFound = false

    for k, v in pairs(Config.Plants) do
        if v.id == plantId then
            for y = 1, #Config.YieldRewards do
                if v.type == Config.YieldRewards[y].type then
                    label = Config.YieldRewards[y].label
                    item = Config.YieldRewards[y].item
                    amount = math.random(Config.YieldRewards[y].rewardMin, Config.YieldRewards[y].rewardMax)
                    local quality = math.ceil(v.quality)
                    hasFound = true
                    table.remove(Config.Plants, k)
                    if quality > 94 then
                        goodQuality = true
                    end
                    amount = math.ceil(amount * (quality / 35))
                end
            end
        end
    end

    if hasFound then
        TriggerClientEvent('wu_weed:client:removeWeedObject', -1, plantId)
        TriggerEvent('wu_weed:server:weedPlantRemoved', plantId)
        TriggerEvent('wu_weed:server:updatePlants')
        if label ~= nil then
            TriggerClientEvent('wu_weed:client:notify', src,  Config.Notifications.Harvested.. ' ' ..amount.. ' ' ..label)
        end
        vRP.giveInventoryItem({user_id, item, amount})
        if goodQuality then
            if math.random(1, 10) > 3 then
                local seed = math.random(1, #Config.GoodSeedRewards)
                vRP.giveInventoryItem({user_id, Config.GoodSeedRewards[seed], math.random(2, 4)})
            end
        else
            vRP.giveInventoryItem({user_id, Config.BadSeedRewards, math.random(1, 2)})
        end
    else
        print('did not find')
    end
end)

RegisterServerEvent('wu_weed:server:updatePlants')
AddEventHandler('wu_weed:server:updatePlants', function()
    TriggerClientEvent('wu_weed:client:updateWeedData', -1, Config.Plants)
end)

RegisterServerEvent('wu_weed:server:waterPlant')
AddEventHandler('wu_weed:server:waterPlant', function(plantId)
    local src = source
    local user_id = vRP.getUserId({src})

    for k, v in pairs(Config.Plants) do
        if v.id == plantId then
            Config.Plants[k].thirst = Config.Plants[k].thirst + Config.ThirstIncrease
            if Config.Plants[k].thirst > 100.0 then
                Config.Plants[k].thirst = 100.0
            end
        end
    end

    vRP.tryGetInventoryItem({user_id, Config.Fertilizing.FertilizingOne, 1})
    TriggerEvent('wu_weed:server:updatePlants')
end)

RegisterServerEvent('wu_weed:server:feedPlant')
AddEventHandler('wu_weed:server:feedPlant', function(plantId)
    local src = source
    local user_id = vRP.getUserId({src})

    for k, v in pairs(Config.Plants) do
        if v.id == plantId then
            Config.Plants[k].hunger = Config.Plants[k].hunger + Config.HungerIncrease
            if Config.Plants[k].hunger > 100.0 then
                Config.Plants[k].hunger = 100.0
            end
        end
    end

    vRP.tryGetInventoryItem({user_id, Config.Fertilizing.FertilizingTwo, 1})
    TriggerEvent('wu_weed:server:updatePlants')
end)

RegisterServerEvent('wu_weed:server:updateWeedPlant')
AddEventHandler('wu_weed:server:updateWeedPlant', function(id, data)
    local result = MySQL.Sync.fetchAll('SELECT * FROM weed_plants')

    if result[1] then
        for i = 1, #result do
            local plantData = json.decode(result[i].properties)
            if plantData.id == id then
                local newData = json.encode(data)
                MySQL.Async.execute('UPDATE weed_plants SET properties = @properties WHERE id = @id', {
                    ['@properties'] = newData,
                    ['@id'] = result[i].id,
                }, function ()
                end)
            end
        end
    end
end)

RegisterServerEvent('wu_weed:server:weedPlantRemoved')
AddEventHandler('wu_weed:server:weedPlantRemoved', function(plantId)
    local result = MySQL.Sync.fetchAll('SELECT * FROM weed_plants')

    if result then
        for i = 1, #result do
            local plantData = json.decode(result[i].properties)
            if plantData.id == plantId then

                MySQL.Async.execute('DELETE FROM weed_plants WHERE id = @id', {
                    ['@id'] = result[i].id
                })

                for k, v in pairs(Config.Plants) do
                    if v.id == plantId then
                        table.remove(Config.Plants, k)
                    end
                end
            end
        end
    end
end)

RegisterServerEvent('wu_weed:server:getWeedPlants')
AddEventHandler('wu_weed:server:getWeedPlants', function()
    local data = {}
    local result = MySQL.Sync.fetchAll('SELECT * FROM weed_plants')

    if result[1] then
        for i = 1, #result do
            local plantData = json.decode(result[i].properties)
            print(plantData.id)
            table.insert(Config.Plants, plantData)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        -- Citizen.Wait(math.random(65000, 75000))
        Citizen.Wait(math.random(20000, 25000))
        -- Citizen.Wait(300)
        for i = 1, #Config.Plants do
            if Config.Plants[i].growth < 100 then
                if Config.Plants[i].grace then
                    Config.Plants[i].grace = false
                else
                    Config.Plants[i].thirst = Config.Plants[i].thirst - math.random(Config.Degrade.min, Config.Degrade.max) / 10
                    Config.Plants[i].hunger = Config.Plants[i].hunger - math.random(Config.Degrade.min, Config.Degrade.max) / 10
                    Config.Plants[i].growth = Config.Plants[i].growth + math.random(Config.GrowthIncrease.min, Config.GrowthIncrease.max) / 10

                    if Config.Plants[i].growth > 100 then
                        Config.Plants[i].growth = 100
                    end

                    if Config.Plants[i].hunger < 0 then
                        Config.Plants[i].hunger = 0
                    end

                    if Config.Plants[i].thirst < 0 then
                        Config.Plants[i].thirst = 0
                    end

                    if Config.Plants[i].quality < 25 then
                        Config.Plants[i].quality = 25
                    end

                    if Config.Plants[i].thirst < 75 or Config.Plants[i].hunger < 75 then
                        Config.Plants[i].quality = Config.Plants[i].quality - math.random(Config.QualityDegrade.min, Config.QualityDegrade.max) / 10
                    end

                    if Config.Plants[i].stage == 1 and Config.Plants[i].growth >= 55 then
                        Config.Plants[i].stage = 2
                    elseif Config.Plants[i].stage == 2 and Config.Plants[i].growth >= 90 then
                        Config.Plants[i].stage = 3
                    end
                end
            end
            TriggerEvent('wu_weed:server:updateWeedPlant', Config.Plants[i].id, Config.Plants[i])
        end
        TriggerEvent('wu_weed:server:updatePlants')
    end
end)
