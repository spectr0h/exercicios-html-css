local backPositions = {
	{ actionId = 15003, toPos = Position(33539, 32209, 7), effect = CONST_ME_SMALLPLANTS },
	{ actionId = 15001, toPos = Position(33430, 32278, 7), effect = CONST_ME_ICEATTACK },
	{ actionId = 15004, toPos = Position(33527, 32301, 4), effect = CONST_ME_ENERGYHIT },
	{ actionId = 15002, toPos = Position(33586, 32263, 7), effect = CONST_ME_MAGIC_RED }
}

local feyristEnter = Action()

function feyristEnter.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for _, feyrist in pairs(backPositions) do
		if item.actionid == feyrist.actionId then
			player:teleportTo(feyrist.toPos)
			player:getPosition():sendMagicEffect(feyrist.effect)
			return true
		end
	end
end

feyristEnter:aid(15001, 15002, 15003, 15004)
feyristEnter:register()
