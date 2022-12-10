Config = {}

Config = {
	Blips = false, -- Enable Blips?
	BlipNamer = false, -- Enable to Name Blips different things, disable if you already have too many blips as this will group them together
	PropSpawn = true, -- Enable Ore Props
	Pedspawn = true, -- Do you want to spawn peds for main locations?
	Invincible = true, --Do you want the peds to be invincible?
	Frozen = true, --Do you want the peds to be unable to move? It's probably a yes, so leave true in there.
	Stoic = true, --Do you want the peds to react to what is happening in their surroundings?
	Fade = true, -- Do you want the peds to fade into/out of existence? It looks better than just *POP* its there.
	Distance = 40.0, --The distance you want peds to spawn at
}

--Blips and Locations
-- Each one has individual blip enablers
-- Mine and Mine Leave have headings for the player locations
Config.Locations =  {
	['Mine'] = { name = "Mine", location = vector3(-595.15,2091.23,131.46-1.03), heading = 61.59, blipTrue = true }, -- The location where you enter the mine 
	['Quarry'] = { name = "Quarry", location = vector3(2961.02, 2754.14, 43.71-1.03), heading = 200.0, blipTrue = true }, -- The location where you enter the mine 
	['Cracking'] = { name = "Stone Cracking", location = vector3(1109.27,-1992.68,30.99-1.03), heading = 305.0-180.0, blipTrue = false }, -- The location of the smelter
}

------------------------------------------------------------
--Ores and Props

Config.OrePositions = {
	---MineShaft Locations
	{ coords = vector3(-587.05, 2059.08, 129.75), },
	{ coords = vector3(-588.49, 2048.05, 129.95-1.0), },
	{ coords = vector3(-580.10, 2037.82, 128.8-1.0), },
	{ coords = vector3(-572.28, 2022.37, 127.93-1.0), },
	{ coords = vector3(-562.8, 2011.85, 127.55-1.0), },
	--Quarry Locations
	{ coords = vector3(2980.37, 2748.4, 43.4-1.5), },
	{ coords = vector3(2985.77, 2751.19, 43.46-1.5), },
	{ coords = vector3(2990.38, 2750.4, 43.46-1.5), },
	{ coords = vector3(3000.77, 2754.15, 43.5-1.5), },
	{ coords = vector3(2977.74, 2741.16, 44.54-1.5), },
}

-----------------------------------------------------------
------------------------------------------------------------

Config.PedList = { -- APPARENTLY You can call config locations IN the config, learn't that one today
	{ model = "S_M_Y_Construct_01", coords = Config.Locations['Mine'].location, heading = Config.Locations['Mine'].heading, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
	{ model = "S_M_Y_Construct_01", coords = Config.Locations['Quarry'].location, heading = Config.Locations['Quarry'].heading, gender = "male", scenario = "WORLD_HUMAN_CLIPBOARD", }, -- Outside Mine
}

------------------------------------------------------------
--Added mine lighting for my first world NVE problems
--Don't always light up...
Config.MineLights = {
	{ coords = vector3(-594.30, 2082.89, 131.40+1.53), },
	{ coords = vector3(-591.85, 2073.95, 131.35+1.53), },
	{ coords = vector3(-589.98, 2066.16, 131.02+1.53), },
	{ coords = vector3(-587.83, 2052.98, 130.21+1.53), },
	{ coords = vector3(-583.94, 2041.11, 129.11+1.53), },
	{ coords = vector3(-577.49, 2030.93, 128.24+1.53), },
	{ coords = vector3(-567.83, 2020.27, 127.58+1.53), },
}

------------------------------------------------------------
--Mining Store Items
Config.Items = {
    label = "Maden Mağazası",  slots = 7,
    items = {
	[1] = { name = "water", price = 30, amount = 100, info = {}, type = "item", slot = 1, },
	[2] = { name = "ekmek", price = 30, amount = 250, info = {}, type = "item", slot = 2, },
	[3] = { name = "bandage", price = 1000, amount = 100, info = {}, type = "item", slot = 3, },
	[4] = { name = "drill",	price = 0, amount = 100, info = {}, type = "item", slot = 4, }, 
	[5] = { name = "handdrill",	price = 0, amount = 100, info = {}, type = "item",	slot = 5, }, }		
}