local animation = function()
    local function distance(x1, y1, x2, y2)
        return ((x2 - x1) ^ 2 + (y2 * 0.66666 - y1 * 0.66666) ^ 2) ^ 0.5
    end

    local function angle(x1, y1, x2, y2)
        -- reverse sign with (x * -1) so we don't swap direction of angle
        return math.atan2((y2 * 0.66666) - (y1 * 0.66666), x2 - x1) * -1
    end

    if GetFurthestFromVita then
        local unit = GetFurthestFromVita()
        if (UnitName(unit)) then
            aura_env.furthestGuy = UnitName(unit)
            local rX, rY = GetPlayerMapPosition(unit)
            local pX, pY = GetPlayerMapPosition("player")
            local facing = math.deg((GetPlayerFacing() - math.pi) * -1)
            local direction = math.deg(angle(rX, rY, pX, pY))
            -- 135 rotation offset for current texture
            -- 90 facing adjustment
            return 135 + direction - 90 + facing
        end
        aura_env.furthestGuy = ""
        aura_env.furthestGuyFacing = ""
    end
    return 135
end

