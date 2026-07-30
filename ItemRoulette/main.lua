-- ==========================================================================
--  Item Roulette - The Binding of Isaac: Repentance
--  Every item pedestal cycles through 5 random items rapidly — time pickup precisely!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("ItemRoulette", 1)
local game = Game()
local rouletteItems = {}  -- {[pedestalIndex] = {items, currentIndex, timer}}
local CYCLE_SPEED = 8  -- Frames between item switches
local ITEMS_PER_PEDESTAL = 5

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, function(_, entity)
    if entity.Type ~= EntityType.ENTITY_PICKUP then return end
    if entity.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end

    local itemPool = game:GetItemPool()
    local itemList = {}

    -- Generate 5 random items for this pedestal
    for i = 1, ITEMS_PER_PEDESTAL do
        local item = itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, false)
        table.insert(itemList, item)
    end

    rouletteItems[entity.InitSeed] = {
        items = itemList,
        currentIndex = 1,
        timer = 0,
    }
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local entities = Isaac.GetRoomEntities()
    for _, entity in ipairs(entities) do
        if entity.Type == EntityType.ENTITY_PICKUP and
           entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            
            local data = rouletteItems[entity.InitSeed]
            if not data then break end

            data.timer = data.timer + 1

            if data.timer >= CYCLE_SPEED then
                data.timer = 0
                data.currentIndex = data.currentIndex % ITEMS_PER_PEDESTAL + 1

                -- Change the pedestal's item
                entity:ToPickup():Morph(entity.Type, entity.Variant,
                    data.items[data.currentIndex], true, true, false)

                -- Visual flash effect
                entity:SetColor(Color(1, 1, 0, 1, 0, 0, 0), CYCLE_SPEED, 1, false, false)
            end
        end
    end
end)

-- Clean up when pedestal is picked up
mod:AddCallback(ModCallbacks.MC_POST_ITEM_PICKUP, function(_, pickupPlayer, itemType)
    local entities = Isaac.GetRoomEntities()
    for _, entity in ipairs(entities) do
        local data = rouletteItems[entity.InitSeed]
        if data then
            for _, item in ipairs(data.items) do
                if item == itemType then
                    rouletteItems[entity.InitSeed] = nil
                    return
                end
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    Isaac.RenderText("ITEM ROULETTE - Time your pickup!",
        200, 10, 0.7, 1, 0.8, 0.2)
end)

Isaac.DebugString("Item Roulette loaded!")
