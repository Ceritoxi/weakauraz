local display = function(_, _, progress)
    local dpspredict = _G.CalculatePainDps()
    local dpsOnTarget = 0
    local target = _G.GlobalDotTable[UnitGUID("target")]
    if target then
        if target["pain"] then
            dpsOnTarget = target["pain"].dps
        end
    end
    return dpsOnTarget, dpspredict
end

