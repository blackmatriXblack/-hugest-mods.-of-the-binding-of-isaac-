-- =============================================================================
--  SilverDollarShop - The Binding of Isaac: Repentance
--  Silver Dollar trinket makes shop items 50% off
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SilverDollarShop", 1)
local TRINKET_SILVER_DOLLAR = 98

function mod:onNewRoom()
    local player = Isaac.GetPlayer(0)
    if not player or not player:HasTrinket(TRINKET_SILVER_DOLLAR) then return end

    local room = Game():GetRoom()
    local roomType = room:GetType()

    if roomType ~= RoomType.ROOM_SHOP then return end

    -- Apply 50% discount to all shop pickups
    local entities = Isaac.GetRoomEntities()
    for _, entity in ipairs(entities) do
        if entity.Type == EntityType.ENTITY_PICKUP
            and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            local pickup = entity:ToPickup()
            if pickup and pickup.Price > 0 then
                pickup.Price = math.max(1, math.floor(pickup.Price * 0.5))
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("SilverDollarShop loaded!")
