-- =============================================================================
--  LaserWidthGrowth - The Binding of Isaac: Repentance
--  Lasers grow wider the longer they fire.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("LaserWidthGrowth", 1)

local MAX_WIDTH = 3.0

function mod:onLaserUpdate(laser)
    if not laser.Visible then return end

    local age = laser.FrameCount
    local width = math.min(0.5 + age * 0.015, MAX_WIDTH)
    laser.Scale = width

    -- Visual: wider laser gets warmer color
    local ratio = width / MAX_WIDTH
    laser.Color = Color(1.0, 1.0 - ratio * 0.7, 0.5 - ratio * 0.3, 1.0, 0, 0, 0)
end

mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.onLaserUpdate)
Isaac.DebugString("LaserWidthGrowth loaded!")
