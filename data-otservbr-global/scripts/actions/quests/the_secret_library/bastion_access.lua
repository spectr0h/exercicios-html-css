local bastionAccess = Action()

function bastionAccess.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target:getId() == 27836 and player:getStorageValue(Storage.TheSecretLibrary.FalconBastionAccess) == 0 then
		player:teleportTo(Position{x = 33357, y = 31308, z = 4})
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

bastionAccess:id(28468)
bastionAccess:register()
