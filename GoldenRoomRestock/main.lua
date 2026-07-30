-- =============================================================================
--  Golden Room Restock - The Binding of Isaac: Repentance
--  All item rooms restock with a new item after being cleared!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GoldenRoomRestock", 1)
local restockedRooms = {}

function mod:onNewRoom()
    local room = Game():GetRoom()
    local roomType = room:GetType()
    local roomIdx = room:GetRoomListIndex()

    -- Check if this is an item room (RoomType.ROOM_TREASURE = 4)
    if roomType == RoomType.ROOM_TREASURE and not restockedRooms[roomIdx] then
        local isClear = room:IsClear()
        if isClear then
            -- Restock with a new pedestal item
            local center = room:GetCenterPos()
            local pool = Game():GetItemPool()
            local newItem = pool:GetCollectible(ItemPoolType.POOL_TREASURE, false)

            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
                newItem, center, Vector.Zero, nil)

            Isaac.DebugString("Item room restocked with new treasure!")
            restockedRooms[roomIdx] = true

            -- Brief visual flare
            Game():ShakeScreen(3)
        end
    end

    -- Reset tracker on new floor
    if room:IsFirstVisit() then
        local level = Game():GetLevel()
        local stage = level:GetStage()
        -- Keep tracking across floors; only clear on new run
    end
end

function mod:onGameStart()
    restockedRooms = {}
    Isaac.DebugString("Golden Room Restock ready!")
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)
Isaac.DebugString("GoldenRoomRestock loaded!")
