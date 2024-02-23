local events = {COMBAT_LOG_EVENT_UNFILTERED}
local trigger = function(_, _, subevent, _, _, castername, _, _, destGUID, _, _, _, _, name)
    if ((subevent == "SPELL_AURA_APPLIED" or subevent == "SPELL_AURA_REFRESH") and name == "Shadow Word: Pain" and
        castername == UnitName("player")) then
        if _G.GlobalDotTable[destGUID] then
            _G.GlobalDotTable[destGUID]["pain"] = {
                time = GetTime(),
                dps = _G.CalculatePainDps()
            }
        else
            _G.GlobalDotTable[destGUID] = {}
            _G.GlobalDotTable[destGUID]["pain"] = {
                time = GetTime(),
                dps = _G.CalculatePainDps()
            }
        end

    end
end

local untrigger = function(_, _, subevent, _, _, castername, _, _, destGUID, _, _, _, _, name)
    if (subevent == "SPELL_AURA_REMOVED" and name == "Shadow Word: Pain" and castername == UnitName("player")) then
        _G.GlobalDotTable[destGUID]["pain"] = nil
    end
end
