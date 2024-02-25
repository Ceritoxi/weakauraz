local function Round(number)
    return math.floor(number + 0.5)
end
local spec = GetSpecialization()
local _, _, class = UnitClass("player")

local generalDamageMods = {
    trick = function()
        if UnitAura("player", "Tricks of the Trade") then
            return 1.15
        else
            return 1
        end
    end,
    jinrokfluid = function()
        if UnitAura("player", "Fluidity") then
            return 1.4
        else
            return 1
        end
    end,
    fearless = function()
        if UnitAura("player", "Fearless") then
            return 1.6
        else
            return 1
        end
    end,
    jikunfood = function()
        if UnitAura("player", "Primal Nutriment") then
            local _, _, _, stack = UnitAura("player", "Primal Nutriment")
            return 2 + (stack and (stack - 1) * 0.1 or 0)
        else
            return 1
        end
    end,
    crit = function(spellSchool, isSpellPowerBased)
        return isSpellPowerBased and (1 + GetSpellCritChance(spellSchool) / 100) or (1 + GetCritChance() / 100)
    end

}

local specificDmgMods = {
    [5] = { -- Priest
        buffs = {
            pi = function()
                if UnitAura("player", "Power Infusion") then
                    return 1.05
                else
                    return 1
                end
            end,
            twist = function()
                if UnitAura("player", "Twist of Fate") then
                    return 1.15
                else
                    return 1
                end
            end
        },
        [3] = { -- Shadow
            buffs = {
                shadowform = function()
                    if UnitAura("player", "Shadowform") then
                        return 1.25
                    else
                        return 1
                    end
                end
            }
        }
    },
    [6] = { -- Death Knight
        [2] = { -- Frost
            ["Frost Fever"] = 1 + (2.0 * GetMastery() / 100)
        },
        [3] = { -- Unholy
            ["Blood Plague"] = (1 + (2.5 * GetMastery() / 100)) * 1.6,
            ["Frost Fever"] = 1.6
        }
    }
}

local function getSpecificDmgMod(spellName)
    local aggregate = 1;
    if specificDmgMods[class] then
        for _, dmgMod in pairs(specificDmgMods[class].buffs) do
            aggregate = aggregate * dmgMod()
        end
        if specificDmgMods[class][spec] then
            for _, dmgMod in pairs(specificDmgMods[class][spec].buffs) do
                aggregate = aggregate * dmgMod()
            end
            aggregate = aggregate * (specificDmgMods[class][spec][spellName] or 1)
        end
    end
    return aggregate
end

local function aggregateDmgMods(spellSchool, isSpellPowerBased, spellName)
    local aggregate = 1;
    for _, dmgMod in pairs(generalDamageMods) do
        aggregate = aggregate * dmgMod(spellSchool, isSpellPowerBased)
    end
    aggregate = aggregate * getSpecificDmgMod(spellName)
    return aggregate
end

aura_env.dots = {
    [1] = {
        baseDamage = 663,
        multiplier = 0.311,
        baseTickRate = 3,
        baseDuration = 18.145,
        school = 6,
        name = "Shadow Word: Pain",
        icon = "Interface\\Icons\\Spell_Shadow_ShadowWordPain",
        isHasteBased = true,
        isSpellPowerBased = true
    },
    [2] = {
        baseDamage = 75,
        multiplier = 0.415,
        baseTickRate = 3,
        baseDuration = 15,
        school = 6,
        name = "Vampiric Touch",
        icon = "Interface\\Icons\\Spell_Holy_Stoicism",
        isHasteBased = true,
        isSpellPowerBased = true
    },
    [3] = {
        baseDamage = 197,
        multiplier = 0.158,
        baseTickRate = 3,
        baseDuration = 30,
        school = 1,
        name = "Blood Plague",
        icon = "Interface\\Icons\\Spell_DeathKnight_BloodPlague",
        isHasteBased = false,
        isSpellPowerBased = false
    },
    [4] = {
        baseDamage = 166,
        multiplier = 0.158,
        baseTickRate = 3,
        baseDuration = 30,
        school = 1,
        name = "Frost Fever",
        icon = "Interface\\Icons\\Spell_DeathKnight_FrostFever",
        isHasteBased = false,
        isSpellPowerBased = false
    }
}

aura_env.dotTable = {}

local dots = aura_env.dots
aura_env.calculateDps = function(dot)
    local haste = UnitSpellHaste("player")
    local isSpellPowerBased = dots[dot].isSpellPowerBased
    local power, positive, negative = dots[dot].isSpellPowerBased and GetSpellBonusDamage(dots[dot].school) or UnitAttackPower("player")
    power = power + (positive or 0) + (negative or 0)
    local damageBonus = aggregateDmgMods(dots[dot].school, isSpellPowerBased, dots[dot].name)
    local damage = 0
    local duration = 1
    if dots[dot].isHasteBased then
        local tickRate = dots[dot].baseTickRate / (1 + (haste / 100))
        local tickAmount = Round(dots[dot].baseDuration / tickRate)
        duration = tickAmount * tickRate
        damage = (dots[dot].baseDamage + tickAmount * power * dots[dot].multiplier) * damageBonus
    else
        damage = (dots[dot].baseDamage + power * dots[dot].multiplier) * damageBonus
    end
    local dps = Round(damage / duration)
    return dps
end

