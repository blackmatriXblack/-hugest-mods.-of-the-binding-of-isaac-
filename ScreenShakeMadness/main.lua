-- =============================================================================
--  Screen Shake Madness - The Binding of Isaac: Repentance
--  Every tear collision causes screen shake!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ScreenShakeMadness", 1)

function mod:onTearCollision(tear, collider)
    if collider then
        local intensity = math.min(tear.Velocity:Length() / 2, 15)
        Game():ShakeScreen(intensity)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_COLLISION, mod.onTearCollision)
Isaac.DebugString("ScreenShakeMadness loaded!")
