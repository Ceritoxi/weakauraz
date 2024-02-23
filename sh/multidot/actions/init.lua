local function Round(number)
    return math.floor(number + 0.5)
end

local dmgMods = {
    shadowform = {
        rawMod = function()
            if UnitAura("player", "Shadowform") then
                return 1.25
            else
                return 1
            end
        end
    },
    twist = {
        rawMod = function()
            if UnitAura("player", "Twist of Fate") then
                return 1.15
            else
                return 1
            end
        end
    },
    pi = {
        rawMod = function()
            if UnitAura("player", "Twist of Fate") then
                return 1.05
            else
                return 1
            end
        end
    },
    trick = {
        rawMod = function()
            if UnitAura("player", "Tricks of the Trade") then
                return 1.15
            else
                return 1
            end
        end
    },
    jinrokfluid = {
        rawMod = function()
            if UnitAura("player", "Fluidity") then
                return 1.4
            else
                return 1
            end
        end
    },
    fearless = {
        rawMod = function()
            if UnitAura("player", "Fearless") then
                return 1.6
            else
                return 1
            end
        end
    },
    jikunfood = {
        rawMod = function()
            if UnitAura("player", "Primal Nutriment") then
                local _, _, _, stack = UnitAura("player", "Primal Nutriment")
                return 2 + (stack and (stack - 1) * 0.1 or 0)
            else
                return 1
            end
        end
    },
    crit = {
        rngMod = function(spellSchool)
            return (1 + GetSpellCritChance(spellSchool) / 100)
        end
    }
}

local function aggregateDmgMods(spellSchool)
    local aggregate = 1;
    local rawAggregate = 1;
    for _, dmgMod in pairs(dmgMods) do
        rawAggregate = rawAggregate * (dmgMod.rawMod ~= nil and dmgMod.rawMod() or 1)
        aggregate = aggregate * (dmgMod.rngMod ~= nil and dmgMod.rngMod(spellSchool) or 1)
    end
    aggregate = aggregate * rawAggregate
    return aggregate, rawAggregate
end

aura_env.dots = {
    [1] = {
        baseDamage = 663,
        multiplier = 0.311,
        baseTickRate = 3,
        baseDuration = 18.145,
        school = 6,
        name = "Shadow Word: Pain",
        icon = "Interface\\Icons\\Spell_Shadow_ShadowWordPain"
    },
    [2] = {
        baseDamage = 75,
        multiplier = 0.415,
        baseTickRate = 3,
        baseDuration = 50,
        school = 6,
        name = "Vampiric Touch",
        icon = "Interface\\Icons\\Spell_Holy_Stoicism"
    }
}

aura_env.dotTable = {}

local dots = aura_env.dots
aura_env.calculateDps = function(dot)
    local haste = UnitSpellHaste("player")
    local spellPower = GetSpellBonusDamage(dots[dot].school)
    local damageBonus, rawDmgBonus = aggregateDmgMods(dots[dot].school)
    local tickRate = dots[dot].baseTickRate / (1 + (haste / 100))
    local tickAmount = Round(dots[dot].baseDuration / tickRate)
    local duration = tickAmount * tickRate
    local damage = (dots[dot].baseDamage + tickAmount * spellPower * dots[dot].multiplier) * damageBonus
    local dps = Round(damage / duration)
    return dps
end
aura_env.lastApplied = {}

