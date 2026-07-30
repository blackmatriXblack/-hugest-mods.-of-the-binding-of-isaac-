-- =============================================================================
--  ROOM TRACKER — The Binding of Isaac: Repentance
--  Displays the current room type name and tracks rooms visited this floor.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RoomTracker", 1)
local roomVisits = {}
local currentRoomName = ""
local roomsVisitedThisFloor = 0

local ROOM_NAMES = {
    [1] = "Default",
    [2] = "Shop",
    [3] = "Error",
    [4] = "Treasure",
    [5] = "Boss",
    [6] = "Mini Boss",
    [7] = "Secret",
    [8] = "Super Secret",
    [9] = "Arcade",
    [10] = "Curse",
    [11] = "Challenge",
    [12] = "Library",
    [13] = "Sacrifice",
    [14] = "Devil",
    [15] = "Angel",
    [16] = "Dungeon",
    [17] = "Boss Rush",
    [18] = "Isaac's Room",
    [19] = "Barren",
    [20] = "Chest",
    [21] = "Dice",
    [22] = "Black Market",
    [23] = "Planetarium",
    [24] = "Teleporter",
    [25] = "Teleporter Exit",
    [26] = "Secret Exit",
    [27] = "Blue",
    [28] = "Ultra Secret",
    [29] = "Bedroom",
    [30] = "Burning Basement",
}

function mod:onNewLevel()
    roomsVisitedThisFloor = 0
    roomVisits = {}
end

function mod:onNewRoom()
    local room = Game():GetRoom()
    if room == nil then return end

    local roomType = room:GetType()
    currentRoomName = ROOM_NAMES[roomType] or ("Room " .. tostring(roomType))

    roomsVisitedThisFloor = roomsVisitedThisFloor + 1
end

function mod:onRender()
    local displayText = "Room: " .. currentRoomName .. " | Visited: " .. tostring(roomsVisitedThisFloor) .. " this floor"
    Isaac.RenderText(displayText, 10, 10, KColor(1, 1, 1, 1), 1.0, 1.0)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("Room Tracker loaded!")
