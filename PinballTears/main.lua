-- ==========================================================================
--  PinballTears - The Binding of Isaac: Repentance
--  Tears bounce off walls 5 times gaining speed each bounce!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("PinballTears", 1)
local BOUNCE_DATA = {}

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    local data = {bounces = 0, maxBounces = 5, speedBoost = 1.3}
    BOUNCE_DATA[tear.InitSeed] = data
end)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
    local data = BOUNCE_DATA[tear.InitSeed]
    if not data or data.bounces >= data.maxBounces then return end

    local vel = tear.Velocity
    local room = Game():GetRoom()
    local pos = tear.Position

    local bounced = false
    if pos.X <= room:GetTopLeftPos().X + 10 then
        vel = Vector( math.abs(vel.X) * data.speedBoost, vel.Y )
        bounced = true
    elseif pos.X >= room:GetBottomRightPos().X - 10 then
        vel = Vector( -math.abs(vel.X) * data.speedBoost, vel.Y )
        bounced = true
    end
    if pos.Y <= room:GetTopLeftPos().Y + 10 then
        vel = Vector( vel.X, math.abs(vel.Y) * data.speedBoost )
        bounced = true
    elseif pos.Y >= room:GetBottomRightPos().Y - 10 then
        vel = Vector( vel.X, -math.abs(vel.Y) * data.speedBoost )
        bounced = true
    end

    if bounced then
        data.bounces = data.bounces + 1
        tear.Velocity = vel
        tear:SetColor(Color(1, 1, 1, 1, 0, 0, 0), 0, 1)
        if data.bounces >= 3 then
            tear:SetColor(Color(1, 0.5, 0.2, 1, 0, 0, 0), 0, 1)
        end
        SFXManager():Play(SoundEffect.SOUND_KEY_PICKUP_GAUNTLET, 0.5, 0, false, 1.0 + data.bounces * 0.3)
    end

    if data.bounces >= data.maxBounces then
        BOUNCE_DATA[tear.InitSeed] = nil
    end
end)

Isaac.DebugString("PinballTears loaded! Bounce 'em all!")
