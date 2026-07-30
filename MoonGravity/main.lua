-- ==========================================================================
--  MoonGravity - The Binding of Isaac: Repentance
--  Low gravity — player jumps higher with knockback amplified and tears float upward!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("MoonGravity", 1)
local GRAVITY = -0.3
local KNOCKBACK_MULT = 2.5

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    local vel = player.Velocity
    player.Velocity = Vector(vel.X, vel.Y + GRAVITY)
end)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, countdown)
    if entity:ToPlayer() then
        local dir = (entity.Position - source.Position):Normalized()
        entity.Velocity = dir * 15 * KNOCKBACK_MULT
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
    local vel = tear.Velocity
    tear.Velocity = Vector(vel.X * 0.7, vel.Y - 0.2)
    tear:SetColor(Color(1, 0.8, 0.9, 1, 0, 0, 0), 0, 1)
end)

Isaac.DebugString("MoonGravity loaded! One small step for Isaac...")
