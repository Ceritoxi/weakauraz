local display = function()
    local dpspredict = aura_env.calculateDps(aura_env.config.dot)
    local dpsOnTarget = 0
    local target = aura_env.dotTable[UnitGUID("target")]
    if target then
        if target[aura_env.dots[aura_env.config.dot].name] then
            dpsOnTarget = target[aura_env.dots[aura_env.config.dot].name].dps
        end
    end
    return dpsOnTarget, dpspredict
end
