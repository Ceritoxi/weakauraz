local events = {UNIT_AURA, PLAYER_TARGET_CHANGED}
local dotrigger = function()
    if (UnitAura("target", aura_env.dots[aura_env.config.dot].name, nil, "PLAYER|HARMFUL")) then
        return true
    end
end

local dountrigger = function()
    if (not UnitAura("target", aura_env.dots[aura_env.config.dot].name, nil, "PLAYER|HARMFUL")) then
        return true
    end
end

local durationtrigger = function()
    local _, _, _, _, _, duration, expirationTime = UnitAura("target", aura_env.dots[aura_env.config.dot].name, nil,
        "PLAYER|HARMFUL")
    return duration, expirationTime
end

local icontrigger = function()
    return aura_env.dots[aura_env.config.dot].icon
end
