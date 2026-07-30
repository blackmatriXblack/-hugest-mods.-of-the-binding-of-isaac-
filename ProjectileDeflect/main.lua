-- =============================================================================
--  ProjectileDeflect — The Binding of Isaac: Repentance
--  30% chance to deflect enemy projectiles back at them.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ProjectileDeflect", 1)

function mod:onProjectileCollision(projectile, collider)
    if projectile and collider and collider:IsPlayer() then
        if math.random() <= 0.3 then
            -- Reverse the projectile's direction
            projectile.Velocity = projectile.Velocity * -1
            -- Set friendly flag if available (makes projectile hit enemies)
            if projectile.ChangeVariant then
                projectile:ChangeVariant(ProjectileVariant.PROJECTILE_NORMAL)
            end
            -- Slight spread for variety
            local angle = projectile.Velocity:GetAngleDegrees()
            local spreadAngle = angle + math.random(-15, 15)
            projectile.Velocity = Vector.FromAngleDegrees(spreadAngle) * projectile.Velocity:Length() * 0.8
            Isaac.DebugString("ProjectileDeflect: Projectile deflected!")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_COLLISION, mod.onProjectileCollision)
Isaac.DebugString("ProjectileDeflect loaded!")
