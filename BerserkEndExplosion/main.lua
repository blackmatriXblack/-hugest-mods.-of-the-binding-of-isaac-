-- =============================================================================
--  BerserkEndExplosion — The Binding of Isaac: Repentance
--  MC_POST_BERSERK: When berserk ends, spawn a large explosion at player
--  position dealing 200 damage to all enemies nearby.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BerserkEndExplosion", 1)

local EXPLOSION_RADIUS = 150
local EXPLOSION_DAMAGE = 200

function mod:onPostBerserk(player, wasBeserk)
    if not player:Exists() then return end
    if not wasBeserk then return end

    local pos = player.Position

    -- Visual: large explosion effect
    local boom = Isaac.Spawn(
        EntityType.ENTITY_EFFECT,
        EffectVariant.HUGE_EXPLOSION,
        0,
        pos,
        Vector.Zero,
        nil
    )

    -- Deal 200 damage to all enemies in radius
    local entities = Isaac.GetRoomEntities()
    for _, entity in ipairs(entities) do
        if entity:Exists() and entity:IsActiveEnemy() then
            local dist = entity.Position:Distance(pos)
            if dist <= EXPLOSION_RADIUS then
                entity:TakeDamage(EXPLOSION_DAMAGE, 0, EntityRef(player), 0)
            end
        end
    end

    -- Clean up berserk state from BerserkStartBuff
    -- (handled via fresh evaluate)
    player:AddCacheFlags(CacheFlag.CACHE_FLYING)
    player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
    player:EvaluateItems()
end
mod:AddCallback(ModCallbacks.MC_POST_BERSERK, mod.onPostBerserk)

Isaac.DebugString("BerserkEndExplosion loaded!")
