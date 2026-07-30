-- =============================================================================
--  TearCollisionExplode — The Binding of Isaac: Repentance
--  Tears explode on hit dealing 10 splash damage in 80 radius.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TearCollisionExplode", 1)

function mod:onTearCollision(tear, collider)
    if collider and tear then
        -- Spawn explosion effect at tear position
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, tear.Position, Vector.Zero, nil)
        -- Deal 10 splash damage to all enemies within 80 radius
        local entities = Isaac.GetRoomEntities()
        for i = 1, #entities do
            local ent = entities[i]
            if ent:IsVulnerableEnemy() then
                if ent.Position:Distance(tear.Position) <= 80 then
                    ent:TakeDamage(10, DamageFlag.DAMAGE_EXPLOSION, EntityRef(tear.SpawnerEntity), 0)
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_COLLISION, mod.onTearCollision)
Isaac.DebugString("TearCollisionExplode loaded!")
