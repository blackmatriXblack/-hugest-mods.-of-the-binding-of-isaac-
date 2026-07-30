-- ==========================================================================
--  CritChance - The Binding of Isaac: Repentance
--  10% chance tears deal 5x crit damage with a flash effect!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("CritChance", 1)
local CRIT_CHANCE = 0.10
local CRIT_MULT = 5.0

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    if math.random() < CRIT_CHANCE then
        tear.CollisionDamage = tear.CollisionDamage * CRIT_MULT
        tear:SetColor(Color(1, 1, 0.3, 1, 0, 0, 0), 0, 99)
        tear.Scale = tear.Scale * 1.5
        tear:AddTearFlags(TearFlags.TEAR_BOUNCE)

        local spark = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_FLAME, 0,
            tear.Position, Vector.Zero, nil)
        if spark then spark:SetTimeout(8) end

        SFXManager():Play(SoundEffect.SOUND_RAZOR, 0.6, 0, false, 1.8 + math.random() * 0.3)
    end
end)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, countdown)
    if source and source.Type == EntityType.ENTITY_TEAR and source.Entity.CollisionDamage > 10 then
        entity:SetColor(Color(5, 5, 2, 1, 0, 0, 0), 3, 1, false, true)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0,
            entity.Position, Vector.Zero, entity):SetTimeout(10)
    end
end)

Isaac.DebugString("CritChance loaded! CRITICAL HIT!")
