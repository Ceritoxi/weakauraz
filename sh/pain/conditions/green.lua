local events = {UNIT_POWER_FREQUENT}
local condition = function()
    local dpspredict = _G.CalculatePainDps()
    local dpsOnTarget = 0
    local target = _G.GlobalDotTable[UnitGUID("target")]
    if target then
        if target["pain"] then
            dpsOnTarget = target["pain"].dps
        end
    end

    local margin = 0.1
    return dpsOnTarget + (dpsOnTarget * margin) < dpspredict
end

