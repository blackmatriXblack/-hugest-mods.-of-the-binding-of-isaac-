-- =============================================================================
--  UltraSecretFinder — The Binding of Isaac: Repentance
--  Red rooms adjacent to ultra secret rooms have a faint red glow on minimap.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("UltraSecretFinder", 1)

function mod:DetectUltraSecretAdjacent()
    local room = Game():GetRoom()
    local level = Game():GetLevel()
    local roomDesc = level:GetCurrentRoomDesc()

    if not roomDesc then return end

    local adjacentRooms = level:GetAdjacentRooms(roomDesc.GridIndex, false)
    if not adjacentRooms then return end

    for i = 0, adjacentRooms.Size - 1 do
        local adjIdx = adjacentRooms:Get(i)
        local adjDesc = level:GetRoomByIdx(adjIdx)
        if adjDesc and adjDesc.Data and adjDesc.Data.Type == RoomType.ROOM_ULTRASECRET then
            -- This room is adjacent to ultra secret — mark it
            room:SetMinimapRevealed(true)

            -- Add red tint visual indicator on the room
            local center = room:GetCenterPos()
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0,
                center, Vector.Zero, nil):SetTimeout(15)
            break
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.DetectUltraSecretAdjacent)
Isaac.DebugString("UltraSecretFinder loaded!")
