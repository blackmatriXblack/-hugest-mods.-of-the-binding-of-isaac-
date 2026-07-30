-- =============================================================================
--  UseItemMultiplier — The Binding of Isaac: Repentance
--  When player uses active item, spawn a copy of charge bar as visual feedback.
--  Also gives +1 damage temporarily after use.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("UseItemMultiplier", 1)

function mod:onUseItem(itemId)
    local player = Isaac.GetPlayer(0)
    local chargeBarPos = player.Position - Vector(0, 50)
    -- Spawn a sparkle pickup as visual feedback for charge bar
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, chargeBarPos, Vector.Zero, nil)
    -- Spawn a small glow effect
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOLY_MANTLE, 0, chargeBarPos + Vector(0, -10), Vector.Zero, nil)
    return nil -- allow item use to proceed normally
end

function mod:onPostUseItem(itemId)
    local player = Isaac.GetPlayer(0)
    -- Temporary +1 damage for the room
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:AddDamage(1.0, 0, EntityType.ENTITY_PLAYER, false)
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem)
mod:AddCallback(ModCallbacks.MC_POST_USE_ITEM, mod.onPostUseItem)
Isaac.DebugString("UseItemMultiplier loaded!")
