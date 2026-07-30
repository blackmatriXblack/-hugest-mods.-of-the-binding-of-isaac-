-- =============================================================================
--  SecretRoomRadar — The Binding of Isaac: Repentance
--  Adjacent rooms to secret room have subtle particle effects on their doors.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SecretRoomRadar", 1)

function mod:MarkSecretAdjacentDoors()
    local room = Game():GetRoom()
    local level = Game():GetLevel()
    local roomDesc = level:GetCurrentRoomDesc()

    if not roomDesc then return end

    local adjacentRooms = level:GetAdjacentRooms(roomDesc.GridIndex, true)
    if not adjacentRooms then return end

    for i = 0, adjacentRooms.Size - 1 do
        local adjRoomIdx = adjacentRooms:Get(i)
        local adjDesc = level:GetRoomByIdx(adjRoomIdx)
        if adjDesc and adjDesc.Data then
            local roomType = adjDesc.Data.Type
            if roomType == RoomType.ROOM_SECRET or roomType == RoomType.ROOM_SUPERSECRET then
                -- Spawn subtle particle effect on each door of the current room
                for d = 0, 7 do
                    local door = room:GetDoor(d)
                    if door and door.TargetRoomIndex == adjRoomIdx then
                        local pos = room:GetDoorSlotPosition(d)
                        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0,
                            pos, Vector.Zero, nil)
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.MarkSecretAdjacentDoors)
Isaac.DebugString("SecretRoomRadar loaded!")
