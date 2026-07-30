-- =============================================================================
--  ProjectileColorCycle - The Binding of Isaac: Repentance
--  All enemy projectiles cycle through rainbow colors.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ProjectileColorCycle", 1)

function mod:onProjectileUpdate(projectile)
    if not projectile.Visible then return end

    local t = projectile.FrameCount * 0.05
    local r = (math.sin(t) + 1) / 2
    local g = (math.sin(t + 2.094) + 1) / 2
    local b = (math.sin(t + 4.188) + 1) / 2

    projectile.Color = Color(r, g, b, 1.0, r * 0.5, g * 0.5, b * 0.5)
end

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.onProjectileUpdate)
Isaac.DebugString("ProjectileColorCycle loaded!")
