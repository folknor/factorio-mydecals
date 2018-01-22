
local decalPrints = nil
local decalItems = nil
local decalEntities = nil
local bluePrintItems = nil

local function buildDecalItems()
	decalItems = {}
	decalEntities = {}
	decalPrints = {}
	local pos = { x = 0, y = 0 }

	-- We only do this once, so #care
	for name in pairs(game.entity_prototypes) do
		if name and name:find("^folkdecal") then
			decalItems[#decalItems + 1] = name
			decalEntities[name] = "decorative-" .. name
			decalPrints[name] = {{
				entity_number = 1,
				name = name,
				position = pos
			}}
		end
	end
	bluePrintItems = { name = "decal-blueprint", count = #decalItems }
end

local function ensureDecals(book)
	local main = book.get_inventory(defines.inventory.item_main)
	if not decalItems then buildDecalItems() end

	main.clear()

	local inserted = main.insert(bluePrintItems)
	if inserted ~= bluePrintItems.count then return end

	for i, decal in next, decalItems do
		local blueprint = main[i]
		blueprint.set_blueprint_entities(decalPrints[decal])
	end
end

local function ensureBook(player)
	local invMain = player.get_inventory(defines.inventory.player_main)
	if invMain and invMain.valid then
		local b = invMain.find_item_stack("decal-book")
		if b then return b end
	end

	local invQuick = player.get_inventory(defines.inventory.player_quickbar)
	if invQuick and invQuick.valid then
		local b = invQuick.find_item_stack("decal-book")
		if b then return b end
	end

	local findHere
	if invMain.can_insert("decal-book") then
		findHere = invMain
		invMain.insert("decal-book")
	elseif invQuick.can_insert("decal-book") then
		findHere = invQuick
		invQuick.insert("decal-book")
	end
	if findHere then
		for i = 1, #findHere do
			if findHere[i].name == "decal-book" then
				return findHere[i]
			end
		end
	end
end

script.on_event(defines.events.on_built_entity, function(event)
	if not decalEntities then return end
	local e = event.created_entity
	if e.name and e.name == "entity-ghost" and e.ghost_name and e.ghost_type and e.ghost_type == "lamp" and decalEntities[e.ghost_name] then
		e.surface.create_decoratives({
			check_collision = false,
			decoratives = {
				{
					name = decalEntities[e.ghost_name],
					position = e.position,
					amount = 1
				}
			}
		})
		e.surface.create_entity({name = "decal-spray", position = e.position})
		e.destroy()
	end
end)

do
	local function onInventoryChanged(player, inventory)
		local decal = inventory.find_item_stack("decal-blueprint")
		if not decal then return end
		decal.clear() -- Nukes it
		local book = ensureBook(player)
		if book then ensureDecals(book) end
	end
	script.on_event(defines.events.on_player_main_inventory_changed, function(event)
		local p = game.players[event.player_index]
		onInventoryChanged(p, p.get_inventory(defines.inventory.player_main))
	end)
	script.on_event(defines.events.on_player_quickbar_inventory_changed, function(event)
		local p = game.players[event.player_index]
		onInventoryChanged(p, p.get_inventory(defines.inventory.player_quickbar))
	end)
end

do
	local function onCursorChanged(event)
		local p = game.players[event.player_index]
		if p.cursor_stack and p.cursor_stack.valid and p.cursor_stack.valid_for_read and p.cursor_stack.name == "decal-blueprint" then
			-- Makes the item move to the inventory and triggers onInventoryChanged below
			p.clean_cursor()
		end
	end
	script.on_event(defines.events.on_player_cursor_stack_changed, onCursorChanged)
end

do
	local function ensure(player)
		if not player or not player.valid then return end
		local book = ensureBook(player)
		if book then ensureDecals(book) end
	end

	local function ensureSingle(event)
		ensure(game.players[event.player_index])
	end
	script.on_event(defines.events.on_player_created, ensureSingle)
	script.on_event(defines.events.on_player_joined_game, ensureSingle)

	local function ensureAll()
		for _, p in pairs(game.players) do ensure(p) end
	end
	script.on_init(ensureAll)
	script.on_configuration_changed(ensureAll)
end
