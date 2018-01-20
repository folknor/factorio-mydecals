
do
	local data = _G.data

	data.zdecals = data.zdecals or {}
	data.zdecals.decals = data.zdecals.decals or {}
	if not data.zdecals.add then
		data.zdecals.add = function(img, icon)
			if type(img) ~= "string" then return end
			if img:find("/") and not img:find("__") then return end

			local i
			local iconType = type(icon)
			if iconType == "boolean" then
				i = "__mydecals__/decals/unknown-icon.png"
			elseif iconType == "string" and icon:find("^__") and icon:find("%.[pngPNG]+$") then
				i = icon
			else
				local check = img:gsub("(%.)([pngPNG]-)$", "-icon.%2")
				if type(check) == "string" and check:find("%-icon%.[pngPNG]+$") then
					i = check
				else
					i = "__mydecals__/decals/unknown-icon.png"
				end
			end

			data.zdecals.decals[img] = i
		end
	end

	local defaultDecals = {
		"factorio-logo",
		"factorio-color",
		"factorio-white",
		"korhal",
		"marshall",
		"mercenary",
		"officer",
		"soldier",
		"Adept_SC2-HotS_Decal1",
		"Broodling_SC2-HotS_Decal1",
		"BroodMaster_SC2-HotS_Decal1",
		"CarbotsProtoss_SC2-HotS_Decal1",
		"CarbotsZerg_SC2-HotS_Decal1",
		"DMW_SC2_Decal1",
		"Executor_SC2-HotS_Decal1",
		"HunterKiller_SC2-HotS_Decal1",
		"Master_SC2-HotS_Decal1",
		"Predator_SC2-HotS_Decal1",
		"Ravager_SC2-HotS_Decal1",
		"Templar_SC2-HotS_Decal1",
		"Torrasque_SC2-HotS_Decal1",
		"abandoned",
		"domination_2",
		"domination_20",
		"extradimensional_02",
		"flag_blocky_9",
		"flag_blocky_20",
		"flag_human_4",
		"flag_human_7",
		"flag_ornate_1",
		"flag_ornate_3",
		"flag_pirate_3",
		"flag_pointy_2",
		"flag_pointy_4",
		"flag_pointy_9",
		"flag_pointy_14",
		"flag_pointy_15",
		"flag_spherical_16",
		"flag_spherical_18",
		"flag_zoological_1",
		"flag_zoological_6",
		"flag_zoological_16",
		"flag_zoological_18",
		"flag_zoological_24",
		"unknown",
	}
	local d = "__mydecals__/decals/"
	for _, decal in next, defaultDecals do
		data.zdecals.decals[d .. decal .. ".png"] = d .. decal .. "-icon.png"
		--data.zdecals.add(d .. decal .. ".png")
	end

	data:extend({
		{
			type = "explosion",
			name = "decal-spray",
			flags = { "not-on-map" },
			animations = { {
				filename = "__mydecals__/graphics/blank.png",
				priority = "low",
				width = 32,
				height = 128,
				frame_count = 1,
				line_length = 1,
				animation_speed = 1
			} },
			light = { intensity = 0, size = 0 },
			sound = { {
				filename = "__mydecals__/spray.ogg",
				volume = 0.7
			} },
		},
		{
			type = "item-group",
			name = "mydecals-mod",
			order = "z",
			inventory_order = "z",
			icon = "__mydecals__/graphics/decal-book.png",
			icon_size = 32,
		},
		{
			type = "item-subgroup",
			name = "decals-core",
			group = "mydecals-mod",
			order = "z",
		},
		{
			type = "item-subgroup",
			name = "decals-3rd-party",
			group = "mydecals-mod",
			order = "z",
		},
	})
end
