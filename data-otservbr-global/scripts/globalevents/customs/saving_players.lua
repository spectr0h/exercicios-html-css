local lastSavedID = 0
local saving_players = GlobalEvent("saving_players")
function saving_players.onThink(interval)
    local players = Game.getPlayers()
    table.sort(players, function (v1, v2) return v1:getGuid() < v2:getGuid() end )
    for index, player in pairs(players) do
         if index > lastSavedID then
             player:save()
             lastSavedID = index
             return true
         end
    end

    lastSavedID = 0
    return true
end

saving_players:interval(10 * 1000)
saving_players:register()