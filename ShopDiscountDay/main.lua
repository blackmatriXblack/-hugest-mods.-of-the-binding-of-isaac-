-- =============================================================================
--  ShopDiscountDay — The Binding of Isaac: Repentance
--  Shop items cost 30% less.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ShopDiscountDay", 1)

local DISCOUNT = 0.7  -- 30% off

function mod:ApplyShopDiscount()
    local room = Game():GetRoom()
    if room:GetType() == RoomType.ROOM_SHOP then
        local entities = Isaac.GetRoomEntities()
        for i = 0, entities.Size - 1 do
            local entity = entities:Get(i)
            if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                local pickup = entity:ToPickup()
                local originalPrice = pickup.Price
                if originalPrice > 0 then
                    pickup.Price = math.max(1, math.floor(originalPrice * DISCOUNT))
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.ApplyShopDiscount)
Isaac.DebugString("ShopDiscountDay loaded!")
