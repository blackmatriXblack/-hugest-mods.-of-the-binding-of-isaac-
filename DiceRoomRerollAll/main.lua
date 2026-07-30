-- =============================================================================
--  DiceRoomRerollAll — The Binding of Isaac: Repentance
--  Dice rooms reroll ALL pedestals on the floor, not just in the room.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DiceRoomRerollAll", 1)

function mod:RerollAllFloorPedestals()
    local room = Game():GetRoom()
    -- Only trigger in dice rooms (room type 11)
    if room:GetType() ~= RoomType.ROOM_DICE then return end

    -- The dice room effect already fired; we re-reroll ALL pedestals on the floor
    local level = Game():GetLevel()
    local rooms = level:GetRooms()

    for i = 0, rooms.Size - 1 do
        local roomDesc = rooms:Get(i)
        local roomEntity = level:GetRoomByIdx(roomDesc.GridIndex)
        if roomEntity then
            local entities = Isaac.GetRoomEntities()
            for j = 0, entities.Size - 1 do
                local entity = entities:Get(j)
                if entity.Type == EntityType.ENTITY_PICKUP
                   and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                    local pickup = entity:ToPickup()
                    if pickup and not pickup:IsShopItem() then
                        pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0, true, true, false)
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, mod.RerollAllFloorPedestals)
Isaac.DebugString("DiceRoomRerollAll loaded!")
