-- =============================================================================
--  ChestTreasureRoom - The Binding of Isaac: Repentance
--  The Chest spawns 6 treasure rooms instead of the default 4 with bonus items
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ChestTreasureRoom", 1)

local function IsTheChest()
    local level = Game():GetLevel()
    return level:GetStage() == LevelStage.STAGE8
       and level:GetStageType() == StageType.STAGETYPE_ORIGINAL
end

local function SpawnExtraTreasureRooms()
    if not IsTheChest() then return end

    local level = Game():GetLevel()
    local room = Game():GetRoom()

    -- Only apply once per floor (starting room is index 0 or so)
    -- The Chest normally has 4 treasure rooms. We add 2 more.
    if not level:IsRoomInMap(GridRooms.ROOM_TREASURE_IDX) then
        -- Check how many treasure rooms exist and add extras
        local treasureRoomCount = 0
        for i = 0, level:GetNumRooms() - 1 do
            if level:GetRoomByIdx(i).Data.Type == RoomType.ROOM_TREASURE then
                treasureRoomCount = treasureRoomCount + 1
            end
        end

        -- If we already have 6+, skip. If fewer, spawn bonus items in existing treasure rooms.
        if treasureRoomCount <= 5 then
            -- Spawn an additional item pedestal in current treasure rooms
            local rooms = level:GetRooms()
            for i = 0, rooms.Size - 1 do
                local roomDesc = rooms:Get(i)
                if roomDesc.Data.Type == RoomType.ROOM_TREASURE then
                    -- Spawn extra item pedestal in treasure room
                    local roomObj = Game():GetRoom()
                    if roomObj:GetType() == RoomType.ROOM_TREASURE then
                        local center = roomObj:GetCenterPos()
                        Isaac.Spawn(
                            EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_COLLECTIBLE,
                            0,
                            Vector(center.X + 40, center.Y),
                            Vector.Zero,
                            nil
                        )
                        Isaac.Spawn(
                            EntityType.ENTITY_PICKUP,
                            PickupVariant.PICKUP_COLLECTIBLE,
                            0,
                            Vector(center.X - 40, center.Y),
                            Vector.Zero,
                            nil
                        )
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, SpawnExtraTreasureRooms)
Isaac.DebugString("ChestTreasureRoom loaded!")
