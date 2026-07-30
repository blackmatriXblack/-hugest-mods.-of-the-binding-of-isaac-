-- =============================================================================
--  Mutual Destruction - The Binding of Isaac: Repentance
--  All enemies die in one hit, but player also dies in one hit!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MutualDestruction", 1)

function mod:onEntitySpawn(entity)
    if entity:IsVulnerableEnemy() then
        entity.HitPoints = 1
        entity.MaxHitPoints = 1
        -- Visually tint enemies red to show they're fragile
        entity:GetSprite().Color = Color(1, 0.3, 0.3, 1, 0, 0, 0)
    end
end

function mod:onEntityTakeDmg(tookDamage, amount, damageFlag, damageSource, damageCountdown)
    if tookDamage.Entity.Type == EntityType.ENTITY_PLAYER and amount > 0 then
        -- One-hit death: set player HP to 0
        local player = tookDamage.Entity:ToPlayer()
        if player then
            player:SetMinDamageCooldown(0)
            -- Remove all hearts
            for i = 1, player:GetMaxHearts() do
                player:AddHearts(-2)
            end
        end
    end
    return nil
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onEntitySpawn)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
Isaac.DebugString("MutualDestruction loaded! One hit = death for everyone!")
