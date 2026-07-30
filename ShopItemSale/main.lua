-- =============================================================================
--  Shop Item Sale - The Binding of Isaac: Repentance
--  All shop items cost only 7 cents! Everything's on sale!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ShopItemSale", 1)
local SALE_PRICE = 7

function mod:onNewRoom()
    local room = Game():GetRoom()
    local roomType = room:GetType()

    -- Only process shop rooms (RoomType.ROOM_SHOP = 2)
    if roomType ~= RoomType.ROOM_SHOP then return end

    local entities = Isaac.GetRoomEntities()
    local saleCount = 0

    for _, entity in ipairs(entities) do
        if entity.Type == EntityType.ENTITY_PICKUP and
           entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then

            local item = entity.SubType
            if item > 0 then
                -- Set the price to 7 cents
                entity:GetData() -- ensure entity data exists
                entity.Price = SALE_PRICE

                -- Visually mark as sale item with green tint
                entity:GetSprite().Color = Color(0.3, 1, 0.3, 1, 0, 0, 0) -- Green = sale!
                entity:GetSprite().PlaybackSpeed = 1.3

                saleCount = saleCount + 1
            end
        end

        -- Also handle shop pickups (bombs, keys, hearts)
        if entity.Type == EntityType.ENTITY_PICKUP and
           (entity.Variant == PickupVariant.PICKUP_BOMB or
            entity.Variant == PickupVariant.PICKUP_KEY or
            entity.Variant == PickupVariant.PICKUP_HEART or
            entity.Variant == PickupVariant.PICKUP_COIN) then

            if entity.Price and entity.Price > SALE_PRICE then
                entity.Price = SALE_PRICE
                entity:GetSprite().Color = Color(0.3, 1, 0.3, 1, 0, 0, 0)
            end
        end
    end

    if saleCount > 0 then
        Isaac.DebugString("SHOP SALE! " .. saleCount .. " items now only 7 cents!")
        Game():ShakeScreen(2)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("ShopItemSale loaded! Everything 7 cents!")
