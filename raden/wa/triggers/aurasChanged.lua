local events = {PLAYER_AURAS_CHANGED}
-- maybe use some other event?
local trigger = function(...)
    aura_env.checkAvailableRunners()
    return true
end

