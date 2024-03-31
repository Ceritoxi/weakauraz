local trim = function(s)
    return s:match("^%s*(.-)%s*$")
end

local function split(inputstr, sep)
    local sep = sep or ","
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, trim(str))
    end
    return t
end

local function distance(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2 + (y2 * 0.66666 - y1 * 0.66666) ^ 2) ^ 0.5
end

local listFromNote = ""

local function generateList()

    local generated = {}
    for unit in WA_IterateGroupMembers() do
        local name = UnitName(unit)
        table.insert(generated, name)
    end

    local roles = {
        ["DAMAGER"] = 1,
        ["NONE"] = 2,
        ["HEALER"] = 3,
        ["TANK"] = 4
    }

    table.sort(generated, function(a, b)
        return roles[UnitGroupRolesAssigned(a)] < roles[UnitGroupRolesAssigned(b)]
    end)
    -- WIP be careful that this will generate before everybody is in raid
    return generated
end

local methods = {
    [1] = function()
        return split(aura_env.config.runners)
    end,
    [2] = function()
        return split(listFromNote)
    end,
    [3] = generateList
}
local names = {}

aura_env.makeRunnerList = function()
    local proritisedMethod = aura_env.config.usedList
    if #(methods[proritisedMethod]()) > 0 then
        names = methods[proritisedMethod]()
        return
    end
    for i = 1, #methods do
        local method = methods[i]
        if #method() > 0 then
            names = method()
            return
        end
    end
    print(proritisedMethod)
    names = methods[3]()
end

aura_env.makeRunnerList()

local note = ""

aura_env.latestVita = "No Vita Yet"

local L_furthestFromVita = "No vita yet"
local L_furthestFromVitaDistance = 0

aura_env.getFurthestFromVita = function()
    local furthestFromVita = "No vita yet"
    local furthestFromVitaDistance = 0
    if aura_env.latestVita and UnitName(aura_env.latestVita) then
        for unit in WA_IterateGroupMembers() do
            if not UnitIsDeadOrGhost(unit) then
                local rX, rY = GetPlayerMapPosition(unit)
                local vX, vY = GetPlayerMapPosition(aura_env.latestVita)
                local distanceFromVita = distance(rX, rY, vX, vY)
                if furthestFromVitaDistance < distanceFromVita then
                    furthestFromVitaDistance = distanceFromVita
                    furthestFromVita = UnitName(unit)
                end
            end
        end
    end
    L_furthestFromVita = furthestFromVita
    L_furthestFromVitaDistance = furthestFromVitaDistance
end

GetFurthestFromVita = function()
    return L_furthestFromVita, L_furthestFromVitaDistance
end

aura_env.availableRunners = {}

aura_env.checkAvailableRunners = function()
    local availableRunners = {}
    for _, name in pairs(names) do
        if UnitName(name) and (((not UnitDebuff(name, "Vita Sensitivity")) and (not UnitDebuff(name, "Unstable Vita"))) and not UnitIsDeadOrGhost(name)) then
            table.insert(availableRunners, name)
        end
    end
    aura_env.availableRunners = availableRunners
end

aura_env.getNoteMsgs = function(msg)
    note = note .. msg
    local startLine = false
    local stopLine = false
    local lines = split(note, "\n")
    for k, v in pairs(lines) do
        if trim(v) == "<radenlist>" then
            startLine = k
        end
        if trim(v) == "</radenlist>" then
            stopLine = k
        end
    end
    if startLine and stopLine then
        listFromNote = lines[startLine + 1]
        aura_env.makeRunnerList()
        aura_env.checkAvailableRunners()
        note = ""
    end
end

aura_env.checkAvailableRunners()

aura_env.toListText = function(list)
    local text = ""
    for _, v in pairs(list) do
        text = text .. v .. "\n"
    end
    return text
end

