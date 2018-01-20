
do
	local data = _G.data
	local decals = {}
	local used = {}

	for img, icon in pairs(data.zdecals.decals) do
		local name = img:match("/([%w%_%-%s]+)%.[pngPNG]-$")
		-- n:find(":") should never happen because we only allow:
		-- %w = alphanumeric a-z 0-9 A-Z
		-- %_ = _
		-- %- = -
		-- %s = space
		if type(name) == "string" and not used[name:lower()] and not name:find(":") then
			name = name:lower()
			used[name] = true
			decals[#decals + 1] = name
			local group = "decals-core"
			if not img:find("^__mydecals__") then group = "decals-3rd-party" end

			name = "folkdecal-" .. name

			local item = {
				type = "item",
				name = name,
				localised_name = {"item-name.decal-blueprint"},
				icon = icon,
				icon_size = 32,
				flags = { "goes-to-quickbar", "hidden" },
				subgroup = group,
				place_result = name,
				stack_size = 1
			}

			local decorative = {
				type = "optimized-decorative",
				name = "decorative-" .. name,
				localised_name = {"item-name.decal-blueprint"},
				icon = icon,
				subgroup = group,
				order = "a", -- Number should be faster, but apparently it's tostring()'d internally anyway
				render_layer = "decorative",
				pictures = { {
					filename = img,
					width = 256,
					height = 256,
				} },
			}

			local fake = table.deepcopy(data.raw["lamp"]["small-lamp"])
			fake.name = name
			fake.subgroup = group
			fake.localised_name = {"item-name.decal-blueprint"}
			fake.icon = icon
			fake.picture_off = {
				filename = img,
				priority = "high",
				width = 256,
				height = 256,
				frame_count = 1,
				axially_symmetrical = false,
				direction_count = 1,
				shift = {-0.015625, 0.15625},
			}
			data:extend({item, fake, decorative})
		end
	end

	data:extend({
		{
			type = "blueprint-book",
			name = "decal-book",
			icon = "__mydecals__/graphics/decal-book.png",
			icon_size = 32,
			flags = {"hidden", "goes-to-main-inventory"},
			subgroup = "decals-core",
			order = "z",
			stack_size = 1,
			inventory_size = #decals,
			enabled = false,
			hidden = true,
		},
		{
			type = "blueprint",
			name = "decal-blueprint",
			localised_name = {"item-name.decal-blueprint"},
			icon = "__mydecals__/graphics/default-decal-icon.png",
			icon_size = 32,
			flags = {"hidden", "goes-to-main-inventory"},
			subgroup = "decals-core",
			order = "z",
			stack_size = 1,
			stackable = false,
			draw_label_for_cursor_render = true,
			selection_color = { r = 0.4, g = 0, b = 0.9 },
			alt_selection_color = { r = 0.4, g = 0, b = 0.9 },
			selection_mode = {"deconstruct"},
			alt_selection_mode = {"deconstruct"},
			selection_cursor_box_type = "not-allowed",
			alt_selection_cursor_box_type = "not-allowed",
			enabled = false,
			hidden = true,
		},
	})
end
