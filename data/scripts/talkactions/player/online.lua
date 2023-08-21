local maxPlayersPerMessage = 10
local playersOnline = TalkAction("!online")

function playersOnline.onSay(player, words, param)
    local hasAccess = player:getGroup():getAccess()
    local players = Game.getPlayers()
    local onlineList = {}

    for _, targetPlayer in ipairs(players) do
        if hasAccess or not targetPlayer:isInGhostMode() then
            table.insert(onlineList, ("%s [%d]"):format(targetPlayer:getName(), targetPlayer:getLevel()))
        end
    end

    local playersOnlineList = #onlineList
    player:sendTextMessage(MESSAGE_ATTENTION, ("%d players online!"):format(playersOnlineList))

    local listPlayers = {}
    for i = 1, playersOnlineList, maxPlayersPerMessage do
        local j = math.min(i + maxPlayersPerMessage - 1, playersOnlineList)
        local sublist = {}
        for k = i, j do
            table.insert(sublist, onlineList[k])
        end
        local msg = table.concat(sublist, ", ") .. "."
        table.insert(listPlayers, table.concat(sublist, "\n"))
        player:sendTextMessage(MESSAGE_ATTENTION, msg)
    end

    player:popupFYI("~ Players Online ~\n\n" .. table.concat(listPlayers, "\n"))
    return false
end

playersOnline:groupType("normal")
playersOnline:register()