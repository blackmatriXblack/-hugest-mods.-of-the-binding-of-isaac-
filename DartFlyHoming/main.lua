-- =============================================================================
--  DartFlyHoming — The Binding of Isaac: Repentance
--  Dart Fly (Type=22, Variant=23) projectiles home toward player.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DartFlyHoming", 1)

function mod:onProjectileUpdate(proj)
    if proj.SpawnerType ~= 22 or proj.SpawnerVariant ~= 23 then return end

    local player = Isaac.GetPlayer(0)
    if player then
        local dir = (player.Position - proj.Position):Normalized()
        local homingStrength = 0.05
        proj.Velocity = (proj.Velocity * (1 - homingStrength)) + (dir * proj.Velocity:Length() * homingStrength)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.onProjectileUpdate)
Isaac.DebugString("DartFlyHoming loaded!")
