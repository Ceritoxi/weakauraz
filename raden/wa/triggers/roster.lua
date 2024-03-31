local events = {GROUP_ROSTER_CHANGED, PLAYER_ALIVE, PLAYER_DEAD}
-- maybe use some other event?
local trigger = function(...)
    aura_env.checkAvailableRunners()
    aura_env.refreshRunnerList()
    return true
end

