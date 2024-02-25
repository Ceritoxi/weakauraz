local display = function()
    local dpsOnTarget = 0
    if not aura_env.state.unitGUID then
        aura_env.state.unitGUID = aura_env.state.GUID
    end
    local target = aura_env.dotTable[aura_env.state.unitGUID]
    if target then
        if target[aura_env.dots[aura_env.config.dot].name] then
            dpsOnTarget = target[aura_env.dots[aura_env.config.dot].name].dps
        end
    end
    return dpsOnTarget
end

