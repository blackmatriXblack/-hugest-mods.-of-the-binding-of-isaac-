-- =============================================================================
--  RoomRecord - The Binding of Isaac: Repentance
--  Display slowest and fastest room clear times for current floor
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RoomRecord", 1)
local game = Game()

local roomStartFrame = 0
local fastestRoom = nil -- {time, roomType}
local slowestRoom = nil -- {time, roomType}
local roomsCleared = 0
local currentRoomStarted = false

function mod:onNewLevel()
    -- Reset records on new floor
    fastestRoom = nil
    slowestRoom = nil
    roomsCleared = 0
    currentRoomStarted = false
    roomStartFrame = 0
end

function mod:onNewRoom()
    local room = game:GetRoom()
    if room then
        local roomDesc = room:GetCurrentRoomDesc()
        roomStartFrame = game:GetFrameCount()
        currentRoomStarted = true
    end
end

function mod:onRoomClear()
    if not currentRoomStarted or roomStartFrame == 0 then return end

    local clearFrame = game:GetFrameCount()
    local clearTime = (clearFrame - roomStartFrame) / 30.0 -- seconds
    local room = game:GetRoom()

    local roomName = "Room"
    if room then
        local roomDesc = room:GetCurrentRoomDesc()
        local rt = roomDesc.Data and roomDesc.Data.Type
        if rt == RoomType.ROOM_BOSS then roomName = "Boss"
        elseif rt == RoomType.ROOM_TREASURE then roomName = "Treasure"
        elseif rt == RoomType.ROOM_SHOP then roomName = "Shop"
        elseif rt == RoomType.ROOM_CHALLENGE then roomName = "Challenge"
        elseif rt == RoomType.ROOM_MINIBOSS then roomName = "MiniBoss"
        elseif rt == RoomType.ROOM_DEVIL then roomName = "Devil"
        elseif rt == RoomType.ROOM_ANGEL then roomName = "Angel"
        elseif rt == RoomType.ROOM_SECRET then roomName = "Secret"
        elseif rt == RoomType.ROOM_SUPERSECRET then roomName = "S-Secret"
        end
    end

    roomsCleared = roomsCleared + 1

    local record = {time = clearTime, name = roomName, frame = game:GetFrameCount()}

    if not fastestRoom or clearTime < fastestRoom.time then
        fastestRoom = record
    end
    if not slowestRoom or clearTime > slowestRoom.time then
        slowestRoom = record
    end

    currentRoomStarted = false
end

function mod:onRender()
    local sw = Isaac.GetScreenWidth()
    local sh = Isaac.GetScreenHeight()
    local x = sw * 0.018
    local y = sh * 0.72

    Isaac.RenderScaledText("Room Records", x, y, 0.85, 0.85, 1, 0.8, 0.3, 1)

    -- Rooms cleared
    Isaac.RenderScaledText(
        string.format("Cleared: %d", roomsCleared),
        x, y + 16, 0.75, 0.75, 0.8, 0.8, 0.8, 1
    )

    -- Fastest room
    if fastestRoom then
        Isaac.RenderScaledText(
            string.format("Fast: %.1fs (%s)", fastestRoom.time, fastestRoom.name),
            x, y + 32, 0.7, 0.7, 0.3, 1, 0.3, 1
        )
    end

    -- Slowest room
    if slowestRoom then
        Isaac.RenderScaledText(
            string.format("Slow: %.1fs (%s)", slowestRoom.time, slowestRoom.name),
            x, y + 48, 0.7, 0.7, 1, 0.3, 0.3, 1
        )
    end

    -- Current room timer
    if currentRoomStarted and roomStartFrame > 0 then
        local currentTime = (game:GetFrameCount() - roomStartFrame) / 30.0
        Isaac.RenderScaledText(
            string.format("Now: %.1fs", currentTime),
            x, y + 64, 0.7, 0.7, 0.8, 0.8, 0.3, 1
        )
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.onRoomClear)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("RoomRecord loaded!")
