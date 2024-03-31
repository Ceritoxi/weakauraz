local display = function()
    local runners = aura_env.availableRunners
    local furthest, distance = aura_env.getFurthestFromVita()
    if WeakAuras.IsOptionsOpen() then
        runners = {"Pepa", "Pig", "Jumper", "Krokker"}
        furthest, distance = "Pepa", 0.1323
    end
    local red = runners[1] -- table.remove(runners, 1)
    return aura_env.toListText({unpack(runners, 2)}), red, aura_env.latestVita, furthest, math.floor(distance * 1000 / 1.66666 * 100) / 100
end

