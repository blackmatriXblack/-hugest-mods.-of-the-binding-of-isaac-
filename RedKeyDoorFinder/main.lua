-- =============================================================================
--  RedKeyDoorFinder — The Binding of Isaac: Repentance
--  Red Key outlines on minimap show which walls have special rooms behind them.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RedKeyDoorFinder", 1)

function mod:OnNewRoom()
    local level = Game():GetLevel()
    local room = level:GetCurrentRoom()
    local roomIdx = level:GetCurrentRoomIndex()
    local roomDesc = level:GetRoomByIdx(roomIdx)

    if not roomDesc then return end

    -- Check all 4 doors for potential red rooms
    local directions = {
        {DoorSlot.LEFT0,  -1,  0},
        {DoorSlot.RIGHT0,  1,  0},
        {DoorSlot.UP0,     0, -1},
        {DoorSlot.DOWN0,   0,  1},
    }

    for _, dir in ipairs(directions) do
        local door = room:GetDoor(dir[1])
        if door and door:IsHidden() then
            door:SetRoomTypes(RoomType.ROOM_DEFAULT)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)
Isaac.DebugString("RedKeyDoorFinder loaded!")
