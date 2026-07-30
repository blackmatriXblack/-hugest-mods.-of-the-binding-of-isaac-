-- =============================================================================
--  DeathScythes — The Binding of Isaac: Repentance
--  Death (Type=65) scythes home toward player and pierce
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DeathScythes", 1)

local DEATH_SCYTHE_VARIANT = 1 -- Death scythe projectile variant
local HOMING_STRENGTH = 0.05

function mod:onProjectileUpdate(projectile)
    if projectile.Variant ~= DEATH_SCYTHE_VARIANT then
        return
    end

    -- Make scythe pierce enemies
    projectile.Piercing = true

    -- Home toward the nearest player
    local nearestDist = 99999
    local target = nil
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if player and player:IsAlive() then
            local dist = projectile.Position:Distance(player.Position)
            if dist < nearestDist then
                nearestDist = dist
                target = player
            end
        end
    end

    if target then
        local dir = target.Position - projectile.Position
        dir:Normalize()
        projectile.Velocity = Vector.Lerp(projectile.Velocity, dir:Resized(projectile.Velocity:Length()), HOMING_STRENGTH)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PROJECTILE_UPDATE, mod.onProjectileUpdate)
Isaac.DebugString("DeathScythes loaded!")
