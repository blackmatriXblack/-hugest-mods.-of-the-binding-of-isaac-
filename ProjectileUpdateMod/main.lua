-- Accelerate projectiles by multiplying velocity by 1.02 per frame
local mod = RegisterMod("ProjectileUpdateMod", 1)
local game = Game()

function mod:onProjectileUpdate(projectile)
    if projectile and projectile.Velocity then
        projectile.Velocity = projectile.Velocity * 1.02
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.onProjectileUpdate)
Isaac.DebugString("ProjectileUpdateMod loaded! Accelerates projectiles by 2% per frame.")
