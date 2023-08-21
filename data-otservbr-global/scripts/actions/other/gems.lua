local lionsRockSanctuaryPos = Position(33073, 32300, 9)
local lionsRockSanctuaryRockId = 1852
local lionsRockSanctuaryFountainId = 6389

local lionsRock = {
	[25006] = {
		itemId = 21442,
		itemPos = {x = 33069, y = 32298, z = 9},
		storage = Storage.LionsRock.Questline,
		value = 9,
		item = 3030,
		fieldId = 2123,
		message = "You place the ruby on the small socket. A red flame begins to burn.",
		effect = CONST_ME_MAGIC_RED
	},
	[25007] = {
		itemId = 21442,
		itemPos = {x = 33069, y = 32302, z = 9},
		storage = Storage.LionsRock.Questline,
		value = 9,
		item = 3029,
		fieldId = 21463,
		message = "You place the sapphire on the small socket. A blue flame begins to burn.",
		effect = CONST_ME_MAGIC_BLUE
	},
	[25008] = {
		itemId = 21440,
		itemPos = {x = 33077, y = 32302, z = 9},
		storage = Storage.LionsRock.Questline,
		value = 9,
		item = 3033,
		fieldId = 7465,
		message = "You place the amethyst on the small socket. A violet flame begins to burn.",
		effect = CONST_ME_PURPLESMOKE
	},
	[25009] = {
		itemId = 21437,
		itemPos = {x = 33077, y = 32298, z = 9},
		storage = Storage.LionsRock.Questline,
		value = 9,
		item = 9057,
		fieldId = 21465,
		message = "You place the topaz on the small socket. A yellow flame begins to burn.",
		effect = CONST_ME_BLOCKHIT
	}
}

local gems = Action()
function gems.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Small emerald for Kilmaresh quest
	-- see data\scripts\quests\kilmaresh\1-fafnars-wrath\7-four-masks.lua
	if item.itemid == 3032 and target.uid == 40032
				and player:getStorageValue(Storage.Kilmaresh.Sixth.Favor) >= 1
				and not testFlag(player:getStorageValue(Storage.Kilmaresh.Sixth.FourMasks), 4) then
		player:addItem(31371, 1) -- Ivory mask
		item:remove(1)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You hear a *click*. You can now lift the floor tile and discover a secret compartment. A mask made of ivory lies in it.")
		player:setStorageValue(Storage.Kilmaresh.Sixth.Favor, player:getStorageValue(Storage.Kilmaresh.Sixth.Favor) + 1)
		player:setStorageValue(Storage.Kilmaresh.Sixth.FourMasks, setFlag(player:getStorageValue(Storage.Kilmaresh.Sixth.FourMasks), 4))
		return true
	-- Enchanted helmet of the ancients
	elseif player:getItemCount(3030) >= 1 and target.itemid == 3229 then
		target:transform(3230)
		target:decay()
		item:remove(1)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_RED)
		return true
	end

	-- Use gems in the tile of lions rock quest
	local setting = lionsRock[target.uid]
	if not setting then
		return false
	end

	-- Reset lion's fields
	local function lionsRockFieldReset()
		local gemSpot = Tile(setting.itemPos):getItemById(setting.fieldId)
		if gemSpot then
			Game.setStorageValue(GlobalStorage.LionsRockFields, Game.getStorageValue(GlobalStorage.LionsRockFields) - 1)
			gemSpot:remove()
			return true
		end
	end

	-- Check if all lion's fields are set
	local function checkLionsRockFields(storage)
		if Game.getStorageValue(GlobalStorage.LionsRockFields) == 3 then
			local stone = Tile(lionsRockSanctuaryPos):getItemById(lionsRockSanctuaryRockId)
			if stone then
				stone:transform(lionsRockSanctuaryFountainId)
				lionsRockSanctuaryPos:sendMagicEffect(CONST_ME_THUNDER)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Something happens at the center of the room ...')
				player:setStorageValue(storage, 10)
				return true
			end
		end
	end

	-- Delay to create lion's field
	local function lionsRockCreateField(itemPos, fieldId, storage)
		local gemSpot = Tile(itemPos):getItemById(fieldId)
		if not gemSpot then
			Game.createItem(fieldId, 1, itemPos)
			Game.setStorageValue(GlobalStorage.LionsRockFields, Game.getStorageValue(GlobalStorage.LionsRockFields) + 1)
			checkLionsRockFields(storage)
			return true
		end
	end

	if player:getStorageValue(setting.storage) >= setting.value then
		if setting.item == item.itemid then
			local gemSpot = Tile(setting.itemPos):getItemById(setting.fieldId)
			if not gemSpot then
				toPosition:sendMagicEffect(setting.effect)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, setting.message)
				item:remove(1)
				addEvent(lionsRockCreateField, 2 * 1000, setting.itemPos, setting.fieldId, setting.storage)
				addEvent(lionsRockFieldReset, 60 * 1000)
				return true
			end
		end
	end
	return false
end

gems:id(9057)
gems:register()
