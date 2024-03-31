local trim = function(s)
    return s:match("^%s*(.-)%s*$")
end

local removeWhitespace = function(s)
    return s:gsub("%s+", "")
end

local split = function(inputstr, sep)
    sep = sep or " "
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    print("lol")
    return t
end

local function distance(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2 + (y2 * 0.66666 - y1 * 0.66666) ^ 2) ^ 0.5
end

local function angle(x1, y1, x2, y2)
    return math.atan2((y2 * 0.66666) - (y1 * 0.66666), x2 - x1)
end
local function distanceInYard(x1, y1, x2, y2)
    return (((x2 - x1) ^ 2 + (y2 * 0.66666 - y1 * 0.66666) ^ 2) ^ 0.5) * 1000 / 1.66666
end
