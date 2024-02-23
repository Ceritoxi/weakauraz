local events = {COMBAT_LOG_EVENT_UNFILTERED}
local trigger = function(_, _, subevent, _, _, castername, _, _, destGUID, _, _, _, _, name)
    if ((subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH") and name == aura_env.dots[aura_env.config.dot].name and castername == UnitName("player")) then
        if aura_env.dotTable[destGUID] then
            aura_env.dotTable[destGUID][aura_env.dots[aura_env.config.dot].name] = {
                time = GetTime(),
                dps = aura_env.calculateDps(aura_env.config.dot)
            }
        else
            aura_env.dotTable[destGUID] = {}
            aura_env.dotTable[destGUID][aura_env.dots[aura_env.config.dot].name] = {
                time = GetTime(),
                dps = aura_env.calculateDps(aura_env.config.dot)
            }
        end
    end
end

local untrigger = function(_, _, subevent, _, _, castername, _, _, destGUID, _, _, _, _, name)
    if (subevent == "SPELL_AURA_REMOVED" and name == aura_env.dots[aura_env.config.dot].name and castername == UnitName("player")) then
        aura_env.dotTable[destGUID][aura_env.dots[aura_env.config.dot].name] = nil
    end
end
