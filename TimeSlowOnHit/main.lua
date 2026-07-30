-- =============================================================================
--  Time Slow On Hit - The Binding of Isaac: Repentance
--  Taking damage slows all enemies for 3 seconds (bullet time!)
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TimeSlowOnHit", 1)
local slowTimer = 0
local SLOW_DURATION = 3 * 30 -- 3 seconds at ~30fps

function mod:onEntityTakeDmg(tookDamage, amount, damageFlag, damageSource, damageCountdown)
    if tookDamage.Entity.Type == EntityType.ENTITY_PLAYER and amount > 0 then
        slowTimer = SLOW_DURATION
        Isaac.DebugString("BULLET TIME ACTIVATED! Enemies slowed!")
        Game():ShakeScreen(5)
    end
    return nil
end

function mod:onNpcUpdate(npc)
    if slowTimer > 0 then
        -- Slow enemy movement by 70%
        npc.Pathfinder:Move()
        local vel = npc.Velocity
        npc.Velocity = vel * 0.3

        -- Slow enemy projectiles
        if npc:IsVulnerableEnemy() then
            npc:GetSprite().PlaybackSpeed = 0.3
        end

        -- Tint enemies blue during slow-mo
        npc:GetSprite().Color = Color(0.4, 0.4, 1, 1, 0, 0, 0)
    end
end

function mod:onPlayerUpdate(player)
    if slowTimer > 0 then
        slowTimer = slowTimer - 1
        if slowTimer == 0 then
            Isaac.DebugString("Bullet time ended!")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
mod:AddCallback(ModCallbacks.MC_NPC_UPDATE, mod.onNpcUpdate)
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("TimeSlowOnHit loaded!")
