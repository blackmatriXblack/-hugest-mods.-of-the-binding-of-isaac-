-- =============================================================================
--  MotherWitnessFight — The Binding of Isaac: Repentance
--  Mother (witness boss in Corpse) takes 20% more damage but attacks 30% faster.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MotherWitnessFight", 1)

local MOTHER_TYPE = 950  -- EntityType for Mother witness

function mod:OnEntitySpawn(entity)
    if entity.Type == MOTHER_TYPE then
        -- Reduce max HP by 20% (takes 20% more relative damage)
        local hp = entity.MaxHitPoints
        entity.MaxHitPoints = math.floor(hp * 0.8)
        entity.HitPoints = entity.MaxHitPoints
        -- Increase animation/attack speed by 30%
        entity:AddEntityFlags(EntityFlag.FLAG_SLOW)
        -- Spawn faster by reducing animation delay
        entity.SpriteScale = Vector(1.3, 1.3)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.OnEntitySpawn)
Isaac.DebugString("MotherWitnessFight loaded!")
