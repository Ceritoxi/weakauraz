local events = {UNIT_POWER_FREQUENT, UNIT_AURA}
local condition = function()
    local dpspredict = aura_env.calculateDps(aura_env.config.dot)
    local dpsOnTarget = 0
    if not aura_env.state.unitGUID then
        aura_env.state.unitGUID = aura_env.lastApplied[aura_env.dots[aura_env.config.dot].name]
    end
    local target = aura_env.dotTable[aura_env.state.unitGUID]
    if target then
        if target[aura_env.dots[aura_env.config.dot].name] then
            dpsOnTarget = target[aura_env.dots[aura_env.config.dot].name].dps
        end
    end
    local margin = 0.1
    return dpsOnTarget + (dpsOnTarget * margin) < dpspredict
end
