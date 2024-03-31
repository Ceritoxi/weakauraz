local events = {UNIT_POWER_FREQUENT, WORLD_MAP_UPDATE}
local trigger = function(allstate, event, unit)
    local function getTexture(percent, part, numberOfParts)
        local step = 1 / numberOfParts * part
        local halfStep = 1 / numberOfParts * (part - 1) + (1 / numberOfParts / 2)
        if percent >= step then
            return "Interface\\AddOns\\WeakAuras\\Media\\Textures\\hunger.tga"
        end
        if percent >= halfStep then
            return "Interface\\AddOns\\WeakAuras\\Media\\Textures\\half_hunger.tga"
        end
        if percent < halfStep then
            return "Interface\\AddOns\\WeakAuras\\Media\\Textures\\empty_hunger.tga"
        end
        return ""
    end

    if unit == "player" or event == "WORLD_MAP_UPDATE" then
        local max = UnitPowerMax("player")
        local current = UnitPower("player")
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

