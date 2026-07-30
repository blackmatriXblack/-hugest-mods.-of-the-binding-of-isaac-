-- =============================================================================
--  DoubleTreasureRooms — The Binding of Isaac: Repentance
--  Every treasure room has 2 item pedestals instead of 1.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DoubleTreasureRooms", 1)

function mod:DoubleTreasureRoomItems()
    local room = Game():GetRoom()
    if room:GetType() == RoomType.ROOM_TREASURE then
        local center = room:GetCenterPos()
        -- Spawn a second random collectible pedestal slightly offset
        local offset = Vector(40, 0)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0,
            center + offset, Vector.Zero, nil)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.DoubleTreasureRoomItems)
Isaac.DebugString("DoubleTreasureRooms loaded!")
