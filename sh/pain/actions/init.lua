local function Round(number)
    return math.floor(number + 0.5)
end

local function nutrimentextra()
    local _, _, _, stack = UnitAura("player", "Primal Nutriment")
    return stack and (stack - 1) * 0.1 or 0
end

local dmgMods = {
    shadowform = {
        rawMod = 1.25,
        check = UnitAura("player", "Shadowform")
    },
    trick = {
        rawMod = 1.15,
        check = UnitAura("player", "Tricks of the Trade")
    },
    jinrokfluid = {
        rawMod = 1.4,
        check = UnitAura("player", "Fluidity")
    },
    fearless = {
        rawMod = 1.6,
        check = UnitAura("player", "Fearless")
    },
    jikunfood = {
        rawMod = 2 + nutrimentextra(),
        check = UnitAura("player", "Primal Nutriment")
    },
    crit = {
        rngMod = (1 + GetSpellCritChance(6) / 100),
        check = true
    }
}

_G.GlobalDotTable = {}

_G.CalculatePainDps = function()
    local function aggregateDmgMods()
        local aggregate = 1;
        local rawAggregate = 1;
        for _, dmgMod in pairs(dmgMods) do
            if (dmgMod.check) then
                aggregate = aggregate * (dmgMod.rawMod ~= nil and dmgMod.rawMod or 1)
                aggregate = aggregate * (dmgMod.rngMod ~= nil and dmgMod.rngMod or 1)
                rawAggregate = rawAggregate * (dmgMod.rawMod ~= nil and dmgMod.rawMod or 1)
            end
        end
        return aggregate, rawAggregate
    end

    local haste = UnitSpellHaste("player")
    local spellPower = GetSpellBonusDamage(6)
    local damageBonus, rawDmgBonus = aggregateDmgMods()

    local tickRate = 3 / (1 + (haste / 100))
    local tickAmount = Round(18.145 / tickRate)
    local duration = tickAmount * tickRate
    local damage = (663 + tickAmount * spellPower * 0.311) * damageBonus
    local dps = Round(damage / duration)
    return dps
end

