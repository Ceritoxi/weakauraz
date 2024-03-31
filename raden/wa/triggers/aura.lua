local events = {UNIT_AURA}
-- maybe use some other event?
local trigger = function(_, unitID)
    unitID = unitID or "player"
    aura_env.checkAvailableRunners()
    if UnitDebuff(unitID, "Unstable Vita") then
        aura_env.latestVita = UnitName(unitID)
    end
    return true
end

