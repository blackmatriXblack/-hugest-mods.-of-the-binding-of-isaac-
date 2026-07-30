-- =============================================================================
--  LaserSplitEnd - The Binding of Isaac: Repentance
--  Laser beams split into 3 small tears when they hit a wall.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("LaserSplitEnd", 1)

local laserSplit = {}

function mod:onLaserUpdate(laser)
    if not laser.Visible then return end

    local ptr = GetPtrHash(laser)
    if laserSplit[ptr] then return end  -- already split

    local room = Game():GetRoom()
    local pos = laser.Position

    -- Check if laser endpoint hits wall
    local tl = room:GetTopLeftPos()
    local br = room:GetBottomRightPos()

    if pos.X <= tl.X + 5 or pos.X >= br.X - 5 or
       pos.Y <= tl.Y + 5 or pos.Y >= br.Y - 5 then

        laserSplit[ptr] = true
        local player = Isaac.GetPlayer(0)
        if not player then return end

        -- Fire 3 small tears in a fan
        local dir = laser.Direction
        local baseAngle = dir:GetAngleDegrees()
        for i = -1, 1 do
            local angle = baseAngle + i * 20
            local angRad = math.rad(angle)
            local tDir = Vector(math.cos(angRad), math.sin(angRad))
            local t = player:FireTear(pos, tDir * 6, false, false, false)
            t.Scale = 0.5
            t.Color = Color(1.0, 0.3, 0.0, 1.0, 0, 0, 0)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, mod.onLaserUpdate)
Isaac.DebugString("LaserSplitEnd loaded!")
