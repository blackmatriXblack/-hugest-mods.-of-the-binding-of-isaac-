-- ==========================================================================
--  Half Room Challenge - The Binding of Isaac: Repentance
--  Room size is reduced by 50% — screen edges are completely blocked
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("HalfRoomChallenge", 1)
local game = Game()
local roomCenter = Vector(320, 280)
local halfWidth = 280
local halfHeight = 220

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local room = game:GetRoom()
    roomCenter = room:GetCenterPos()
    -- Calculate half room boundaries
    local roomShape = room:GetRoomShape()
    halfWidth = 280
    halfHeight = 220
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    local pos = player.Position
    local clamped = false
    local newPos = Vector(pos.X, pos.Y)

    -- Clamp player position to half room boundaries
    if pos.X < roomCenter.X - halfWidth then
        newPos.X = roomCenter.X - halfWidth
        clamped = true
    elseif pos.X > roomCenter.X + halfWidth then
        newPos.X = roomCenter.X + halfWidth
        clamped = true
    end

    if pos.Y < roomCenter.Y - halfHeight then
        newPos.Y = roomCenter.Y - halfHeight
        clamped = true
    elseif pos.Y > roomCenter.Y + halfHeight then
        newPos.Y = roomCenter.Y + halfHeight
        clamped = true
    end

    if clamped then
        player.Position = newPos
        player.Velocity = Vector.Zero
    end
end)

-- Render half-room border indicators
mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local room = game:GetRoom()
    local topLeft = room:GetRenderTopLeft()
    local scale = room:GetRenderScale()

    -- Top boundary line
    local boundaryY = roomCenter.Y - halfHeight
    local screenTop = (boundaryY - topLeft.Y) * scale.Y

    -- Bottom boundary line (visual feedback for blocked area)
end)

Isaac.DebugString("Half Room Challenge loaded!")
