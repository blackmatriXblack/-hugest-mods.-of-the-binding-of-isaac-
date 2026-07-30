-- =============================================================================
--  TaintedForgottenBones - The Binding of Isaac: Repentance
--  Tainted Forgotten: Thrown bone hits bounce to 1 extra enemy.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedForgottenBones", 1)
local TAINTED_FORGOTTEN = 35
local bounced = {}

function mod:onProjectileUpdate(proj)
    if proj.Variant ~= ProjectileVariant.PROJECTILE_BONE then return end
    local hash = GetPtrHash(proj)
    if bounced[hash] then return end

    -- Find nearest enemy to bounce towards
    local room = Game():GetRoom()
    local projPos = proj.Position
    local closestDist = 9999
    local closestEnemy = nil

    for i = 0, room:GetAliveEnemiesCount() - 1 do
        local enemy = room:GetAliveEnemy(i)
        if enemy and not proj:HasEntityCollided(enemy) then
            local dist = projPos:Distance(enemy.Position)
            if dist < closestDist and dist < 300 then
                closestDist = dist
                closestEnemy = enemy
            end
        end
    end

    if closestEnemy then
        local dir = (closestEnemy.Position - projPos):Normalized()
        proj.Velocity = dir * proj.Velocity:Length()
        bounced[hash] = true
        Isaac.DebugString("TaintedForgottenBones: Bone bounced to nearest enemy!")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.onProjectileUpdate)
Isaac.DebugString("TaintedForgottenBones loaded!")
