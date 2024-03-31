local events = {UNIT_HEALTH_FREQUENT, WORLD_MAP_UPDATE}
local trigger = function(allstate, event, unit)
    local function getTexture(percent, part, numberOfParts)
        local step = 1 / numberOfParts * part
        local halfStep = 1 / numberOfParts * (part - 1) + (1 / numberOfParts / 2)
        if percent >= step then
            return "Interface\\AddOns\\WeakAuras\\Media\\Textures\\heart.tga"
        end
        if percent >= halfStep then
            return "Interface\\AddOns\\WeakAuras\\Media\\Textures\\half_heart.tga"
        end
        if percent < halfStep then
            return "Interface\\AddOns\\WeakAuras\\Media\\Textures\\empty_heart.tga"
        end
        return ""
    end

    if unit == "player" or event == "WORLD_MAP_UPDATE" then
        local max = UnitHealthMax("player")
        local current = UnitHealth("player")
        local percent = current / max
        for i = 1, 10 do
            allstate[i] = {
                show = true,
                texture = getTexture(percent, i, 10)
            }
        end
        return true
    end
end
