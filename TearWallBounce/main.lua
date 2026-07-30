-- =============================================================================
--  TearWallBounce - The Binding of Isaac: Repentance
--  Tears bounce off walls up to 2 times with increased speed.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TearWallBounce", 1)

local MAX_BOUNCES = 2
local bounceData = {}

function mod:onTearUpdate(tear)
    if not tear.Visible then return end

    local ptr = GetPtrHash(tear)
    local data = bounceData[ptr]
    if not data then
        bounceData[ptr] = { bounces = 0 }
        data = bounceData[ptr]
    end

    if data.bounces >= MAX_BOUNCES then return end

    local room = Game():GetRoom()
    local pos = tear.Position
    local vel = tear.Velocity
    local bounced = false

    if pos.X <= room:GetTopLeftPos().X + 10 then
        vel = Vector(vel.X * -1, vel.Y)
        bounced = true
    elseif pos.X >= room:GetBottomRightPos().X - 10 then
        vel = Vector(vel.X * -1, vel.Y)
        bounced = true
    end

    if pos.Y <= room:GetTopLeftPos().Y + 10 then
        vel = Vector(vel.X, vel.Y * -1)
        bounced = true
    elseif pos.Y >= room:GetBottomRightPos().Y - 10 then
        vel = Vector(vel.X, vel.Y * -1)
        bounced = true
    end

    if bounced then
        data.bounces = data.bounces + 1
        tear.Velocity = vel * 1.1
        tear.Color = Color(1.0, 0.6, 0.0, 1.0, 0, 1.0, 0)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.onTearUpdate)
Isaac.DebugString("TearWallBounce loaded!")
