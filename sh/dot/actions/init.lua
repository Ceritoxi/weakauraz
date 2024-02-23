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
    unholy = {
        rawMod = function(spellName)
            local spec = GetSpecialization()
            if spec > 0 then
                local _, _, _, texture = _G.GetSpecializationInfo(spec)
                if texture == "Interface\\Icons\\Spell_Deathknight_UnholyPresence" then
                    if spellName == "Blood Plague" then
                        return (1 + (2.5 * GetMastery() / 100)) * 1.6
                    elseif spellName == "Frost Fever" then
                        return 1.6
                    end
                end
            else
                return 1
            end
        end
    },
    frost = {
        rawMod = function(spellName)
            local spec = GetSpecialization()
            if spellName == "Frost Fever" and spec > 0 then
                local _, _, _, texture = _G.GetSpecializationInfo(spec)
                if texture == "Interface\\Icons\\Spell_Deathknight_FrostPresence" then
                    return 1 + (2.0 * GetMastery() / 100)
                end
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
        rngMod = function(spellSchool, isSpellPowerBased)
            return isSpellPowerBased and (1 + GetSpellCritChance(spellSchool) / 100) or (1 + GetCritChance() / 100)
        end
    }
}

local function aggregateDmgMods(spellSchool, isSpellPowerBased, spellName)
    local aggregate = 1;
    local rawAggregate = 1;
    for _, dmgMod in pairs(dmgMods) do
        rawAggregate = rawAggregate * (dmgMod.rawMod ~= nil and dmgMod.rawMod(spellName) or 1)
        aggregate = aggregate * (dmgMod.rngMod ~= nil and dmgMod.rngMod(spellSchool, isSpellPowerBased) or 1)
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
    local damageBonus, rawDmgBonus = aggregateDmgMods(dots[dot].school, isSpellPowerBased, dots[dot].name)
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

