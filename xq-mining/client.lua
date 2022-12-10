local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
	if Config.PropSpawn == true then
		CreateProps()
	end
end)
Citizen.CreateThread(function()
	if Config.Pedspawn == true then
		CreatePeds()
	end
end)
-----------------------------------------------------------

local peds = {}
local shopPeds = {}
function CreatePeds()
	while true do
		Citizen.Wait(500)
		for k = 1, #Config.PedList, 1 do
			v = Config.PedList[k]
			local playerCoords = GetEntityCoords(PlayerPedId())
			local dist = #(playerCoords - v.coords)
			if dist < Config.Distance and not peds[k] then
				local ped = nearPed(v.model, v.coords, v.heading, v.gender, v.animDict, v.animName, v.scenario)
				peds[k] = {ped = ped}
			end
			if dist >= Config.Distance and peds[k] then
				if Config.Fade then
					for i = 255, 0, -51 do
						Citizen.Wait(50)
						SetEntityAlpha(peds[k].ped, i, false)
					end
				end
				DeletePed(peds[k].ped)
				peds[k] = nil
			end
		end
	end
end

function nearPed(model, coords, heading, gender, animDict, animName, scenario)
	RequestModel(GetHashKey(model))
	while not HasModelLoaded(GetHashKey(model)) do
		Citizen.Wait(1)
	end
	if gender == 'male' then
		genderNum = 4
	elseif gender == 'female' then 
		genderNum = 5
	else
		print("No gender provided! Check your configuration!")
	end
	if Config.MinusOne then 
		local x, y, z = table.unpack(coords)
		ped = CreatePed(genderNum, GetHashKey(model), x, y, z - 1, heading, false, true)
		table.insert(shopPeds, ped)
	else
		ped = CreatePed(genderNum, GetHashKey(v.model), coords, heading, false, true)
		table.insert(shopPeds, ped)
	end
	SetEntityAlpha(ped, 0, false)
	if Config.Frozen then
		FreezeEntityPosition(ped, true) --Don't let the ped move.
	end
	if Config.Invincible then
		SetEntityInvincible(ped, true) --Don't let the ped die.
	end
	if Config.Stoic then
		SetBlockingOfNonTemporaryEvents(ped, true) --Don't let the ped react to his surroundings.
	end
	--Add an animation to the ped, if one exists.
	if animDict and animName then
		RequestAnimDict(animDict)
		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
		TaskPlayAnim(ped, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
	end
	if scenario then
		TaskStartScenarioInPlace(ped, scenario, 0, true) -- begins peds animation
	end
	if Config.Fade then
		for i = 0, 255, 51 do
			Citizen.Wait(50)
			SetEntityAlpha(ped, i, false)
		end
	end
	return ped
end

-----------------------------------------------------------

function CreateProps()
	local prop = 0
	for k,v in pairs(Config.OrePositions) do
		prop = prop+1
		local prop = CreateObject(GetHashKey("cs_x_rubweec"),v.coords.x, v.coords.y, v.coords.z+1.03,false,false,false)
		SetEntityHeading(prop,GetEntityHeading(prop)-90)
		FreezeEntityPosition(prop, true)           
    end
	for k,v in pairs(Config.MineLights) do
		prop = prop+1
		local prop = CreateObject(GetHashKey("xs_prop_arena_lights_ceiling_l_c"),v.coords.x, v.coords.y, v.coords.z+1.03,false,false,false)
		--SetEntityHeading(prop,GetEntityHeading(prop)-90)
		FreezeEntityPosition(prop, true)           
    end

	--Stone Cracking Bench
	local bench2 = CreateObject(GetHashKey("prop_tool_bench02"),Config.Locations['Cracking'].location,false,false,false)
	SetEntityHeading(bench2,GetEntityHeading(bench2)-Config.Locations['Cracking'].heading)
	FreezeEntityPosition(bench2, true)
	--Stone Prop for bench
	local bench2prop = CreateObject(GetHashKey("cs_x_rubweec"),Config.Locations['Cracking'].location.x, Config.Locations['Cracking'].location.y, Config.Locations['Cracking'].location.z+0.83,false,false,false)
	SetEntityHeading(bench2prop,GetEntityHeading(bench2prop)-Config.Locations['Cracking'].heading+90)
	FreezeEntityPosition(bench2prop, true)
	local bench2prop2 = CreateObject(GetHashKey("prop_worklight_03a"),Config.Locations['Cracking'].location.x-1.4, Config.Locations['Cracking'].location.y+1.08, Config.Locations['Cracking'].location.z,false,false,false)
	SetEntityHeading(bench2prop2,GetEntityHeading(bench2prop2)-Config.Locations['Cracking'].heading+180)
	FreezeEntityPosition(bench2prop2, true)
end

-----------------------------------------------------------

Citizen.CreateThread(function()
	exports['qb-target']:AddCircleZone("MineShaft", Config.Locations['Mine'].location, 2.0, { name="MineShaft", debugPoly=false, useZ=true, }, 
	{ options = { { event = "xq-mining:openShop", icon = "fas fa-certificate", label = "Mağazaya Gözat", }, },
		distance = 2.0
	})
	exports['qb-target']:AddCircleZone("Quarry", Config.Locations['Quarry'].location, 2.0, { name="Quarry", debugPoly=false, useZ=true, }, 
	{ options = { { event = "xq-mining:openShop", icon = "fas fa-certificate", label = "Mağazaya Gözat", }, },
		distance = 2.0
	})
	--Cracking Bench
	exports['qb-target']:AddCircleZone("CrackingBench", Config.Locations['Cracking'].location, 2.0, { name="CrackingBench", debugPoly=false, useZ=true, }, 
	{ options = { { event = "xq-mining:CrackStart", icon = "fas fa-certificate", label = "Çatlama Tezgahını Kullan", },	},
		distance = 2.0
	})
	local ore = 0
	for k,v in pairs(Config.OrePositions) do
		ore = ore+1
		exports['qb-target']:AddCircleZone(ore, v.coords, 2.0, { name=ore, debugPoly=false, useZ=true, }, 
		{ options = { { event = "xq-mining:MineOre", icon = "fas fa-certificate", label = "Taş Kır", },	},
			distance = 2.5
		})
	end
end)

-----------------------------------------------------------
--Mining Store Opening
RegisterNetEvent('xq-mining:openShop')
AddEventHandler('xq-mining:openShop', function ()
	TriggerServerEvent("inventory:server:OpenInventory", "shop", "mine", Config.Items)
end)
------------------------------------------------------------
-- Mine Ore Command / Animations

function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 

RegisterNetEvent('xq-mining:MineOre')
AddEventHandler('xq-mining:MineOre', function ()
	QBCore.Functions.TriggerCallback('xqBase:item-kontrol', function(qtty)
		if qtty > 0 then 
			local pos = GetEntityCoords(PlayerPedId())
			loadAnimDict("anim@heists@fleeca_bank@drilling")
			TaskPlayAnim(PlayerPedId(), 'anim@heists@fleeca_bank@drilling', 'drill_straight_idle' , 3.0, 3.0, -1, 1, 0, false, false, false)
			local pos = GetEntityCoords(PlayerPedId(), true)
			local DrillObject = CreateObject(GetHashKey("hei_prop_heist_drill"), pos.x, pos.y, pos.z, true, true, true)
			AttachEntityToEntity(DrillObject, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 57005), 0.14, 0, -0.01, 90.0, -90.0, 180.0, true, true, false, true, 1, true)
			QBCore.Functions.Progressbar("open_locker_drill", "Taş Kazılıyor..", math.random(10000,15000), false, true, {
				disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
				StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
				DetachEntity(DrillObject, true, true)
				DeleteObject(DrillObject)
					TriggerServerEvent('xq-mining:MineReward')
					IsDrilling = false
			end, function() -- Cancel
				StopAnimTask(PlayerPedId(), "anim@heists@fleeca_bank@drilling", "drill_straight_idle", 1.0)
				DetachEntity(DrillObject, true, true)
				DeleteObject(DrillObject)
				IsDrilling = false
			end)
		else
			TriggerEvent('QBCore:Notify', "Üzerinde Büyük Matkap Yok", 'error')
		end 
	end, "drill")
end)

------------------------------------------------------------

-- Cracking Command / Animations
-- Command Starts here where it calls to being the stone inv checking


RegisterNetEvent('xq-mining:CrackStart')
AddEventHandler('xq-mining:CrackStart', function ()
	QBCore.Functions.TriggerCallback('xqBase:item-kontrol', function(qtty)
		if qtty > 0 then
			local pos = GetEntityCoords(PlayerPedId())
			loadAnimDict('amb@prop_human_parking_meter@male@idle_a')
			TaskPlayAnim(PlayerPedId(), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a' , 3.0, 3.0, -1, 1, 0, false, false, false)
			QBCore.Functions.Progressbar("open_locker_drill", "Taş Çatlatılıyor..", math.random(10000,15000), false, true, {
				disableMovement = true,	disableCarMovement = true, disableMouse = false, disableCombat = true, }, {}, {}, {}, function() -- Done
				StopAnimTask(PlayerPedId(), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
				TriggerServerEvent('xq-mining:CrackReward')
				IsDrilling = false
			end, function() -- Cancel
				StopAnimTask(PlayerPedId(), 'amb@prop_human_parking_meter@male@idle_a', 'idle_a', 1.0)
				IsDrilling = false
			end)
		else 
			TriggerEvent('QBCore:Notify', "Üzerinde Hiç Taş Yok", 'error')
		end 
	end, "stone")
end)