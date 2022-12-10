QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('xq-mining:MineReward')
AddEventHandler('xq-mining:MineReward', function()
    local Player = QBCore.Functions.GetPlayer(source)
    -- local randomChance = math.random(1, 3)
    Player.Functions.AddItem('stone', 1)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["stone"], "add", randomChance)
end)

--Stone Cracking Checking Triggers
--Command here to check if any stone is in inventory

RegisterServerEvent('xq-mining:CrackReward')
AddEventHandler('xq-mining:CrackReward', function()
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.RemoveItem('stone', 1)
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["stone"], "remove", 1)
    -- local oreToGive = nil
    -- oreToGive = math.random(1,#Config.RewardPool)
    -- local amount = math.random(1, 2)
	local itemsans = nil
	itemsans = math.random(1, 100)
	if itemsans <= 25 then
		Player.Functions.AddItem("iron", 1)
    	TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["iron"], "add", 1)
	elseif 25 < itemsans and itemsans <= 40 then
		Player.Functions.AddItem("steel", 1)
    	TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["steel"], "add", 1)
	elseif 45 < itemsans and itemsans <= 60 then
		Player.Functions.AddItem("glass", 1)
    	TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["glass"], "add", 1)
	elseif 60 < itemsans and itemsans <= 68 then
		Player.Functions.AddItem("carbon", 1)
    	TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["carbon"], "add", 1)
	elseif 68 < itemsans and itemsans <= 79 then
		Player.Functions.AddItem("metalscrap", 1)
    	TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["metalscrap"], "add", 1)
	elseif 79 < itemsans and itemsans <= 80 then
		Player.Functions.AddItem("goldbar", 1)
    	TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["goldbar"], "add", 1)
	elseif 80 < itemsans and itemsans <= 100 then
		Player.Functions.AddItem("copper", 1)
    	TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items["copper"], "add", 1)
	end
end)

QBCore.Functions.CreateCallback('xqBase:item-kontrol', function(source, cb, item)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    if xPlayer then  
        local items = xPlayer.Functions.GetItemByName(item)
        if items == nil then
            cb(0)
        else
            cb(items.amount)
        end
    end
end)
