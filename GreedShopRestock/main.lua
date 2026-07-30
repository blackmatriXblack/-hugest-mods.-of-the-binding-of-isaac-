-- =============================================================================
--  GreedShopRestock — The Binding of Isaac: Repentance
--  Greed mode shop restocks 2 items per wave instead of 1.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GreedShopRestock", 1)

local RESTOCK_COUNT = 2

function mod:DoubleGreedRestock()
    local game = Game()
    if not game:IsGreedMode() then return end

    local room = game:GetRoom()
    if room:GetType() ~= RoomType.ROOM_SHOP then return end

    local entities = Isaac.GetRoomEntities()
    local shopItems = {}

    for i = 0, entities.Size - 1 do
        local entity = entities:Get(i)
        if entity.Type == EntityType.ENTITY_PICKUP
           and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            local pickup = entity:ToPickup()
            if pickup and pickup:IsShopItem() then
                table.insert(shopItems, pickup)
            end
        end
    end

    -- Spawn extra shop items per wave
    local center = room:GetCenterPos()
    for i = 1, RESTOCK_COUNT - 1 do
        local offset = Vector((i * 40) - 20, 0)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0,
            center + offset, Vector.Zero, nil):ToPickup():SetShopItem(true)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.DoubleGreedRestock)
Isaac.DebugString("GreedShopRestock loaded!")
