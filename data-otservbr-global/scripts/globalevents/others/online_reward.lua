local config = {
    seconds = 3600, -- 3600 = 1 hour
    eventInterval = 1000, -- 1 second
    checkIP = true,
    checkAccount = true,
    allowMCs = 5,
    storageKey = 45000,
    rewards = {
        -- { itemId = 3043, count = 1 },
        { name = "Tibia Coins", itemDb = 'accounts', value = 'coins_transferable', count = 2 }
    }
}

local onlineTimeRewards = GlobalEvent("onlineTimeRewards")

function onlineTimeRewards.onThink(interval)
    local duplicateIps = {}
    local duplicateAccounts = {}
    for _, player in pairs(Game.getPlayers()) do repeat
        local ip = player:getIp()
        if config.checkIP and ip == 0 or (duplicateIps[ip] or 0) >= config.allowMCs then
            break
        end
        duplicateIps[ip] = duplicateIps[ip] and duplicateIps[ip] + 1 or 1
        local accountId = player:getAccountId()
        if config.checkAccount and (duplicateAccounts[accountId] or 0) >= config.allowMCs then
            break
        end
        duplicateAccounts[accountId] = duplicateAccounts[accountId] and duplicateAccounts[accountId] + 1 or 1
        local seconds = math.max(player:getStorageValue(config.storageKey), 0) + math.ceil(interval/1000)
        if seconds >= config.seconds then
            player:setStorageValue(config.storageKey, 0)
            local rewards = {}
            for _, reward in pairs(config.rewards) do
                if reward.itemDb then
                    if db.query(string.format("UPDATE `%s` SET `%s` = `%s` + %d WHERE `id` = %d", reward.itemDb, reward.value, reward.value, reward.count, accountId)) then
                        rewards[#rewards + 1] = string.format('%dx %s', reward.count, reward.name)
                    else
                        print(string.format("[onlineTimeRewards] Error while rewarding player %s.", player:getName()))
                    end
                else
                    local item = player:addItem(reward.itemId, reward.count)
                    if item then
                        rewards[#rewards + 1] = string.format('%s x%d', item:getName(), reward.count)
                    end
                end
            end
            player:sendTextMessage(MESSAGE_STATUS_DEFAULT, "You have received " .. table.concat(rewards, ', ') .. " for being online for 1 hour!")
            break
        end
        player:setStorageValue(config.storageKey, seconds)
    until true end
    return true
end

onlineTimeRewards:interval(config.eventInterval)
onlineTimeRewards:register()