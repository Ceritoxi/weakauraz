local events = {COMBAT_LOG_EVENT_UNFILTERED}
local dotrigger = function(_, _, subevent, _, _, castername, _, _, destGUID, _, _, _, _, name)
    if ((subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH") and name == aura_env.dots[aura_env.config.dot].name and castername == UnitName("player")) then
        -- aura_env.lastApplied[aura_env.dots[aura_env.config.dot].name] = destGUID
        -- using state.GUID
        return true
    end
end

local dountrigger = function()
    return true
end
