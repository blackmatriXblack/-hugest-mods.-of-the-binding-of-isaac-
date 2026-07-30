-- =============================================================================
--  ProjectileSlowField - The Binding of Isaac: Repentance
--  Enemy projectiles slow down by 40% when near the player.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ProjectileSlowField", 1)

local SLOW_ZONE = 100
local SLOW_FACTOR = 0.4

function mod:onProjectileUpdate(projectile)
    if not projectile.Visible then return end

    local player = Isaac.GetPlayer(0)
    if not player then return end

    local dist = (projectile.Position - player.Position):Length()
    if dist < SLOW_ZONE then
        local factor = 1.0 - SLOW_FACTOR
        projectile.Velocity = projectile.Velocity * (1.0 - 0.02)
        projectile.Color = Color(0.3, 0.5, 1.0, 1.0, 0, 0, 0)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.onProjectileUpdate)
Isaac.DebugString("ProjectileSlowField loaded!")
