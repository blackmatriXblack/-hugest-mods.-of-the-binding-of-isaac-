-- ==========================================================================
--  Item Tax - The Binding of Isaac: Repentance
--  Picking up items costs coins — 5 for passive, 10 for active items
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("ItemTax", 1)
local game = Game()

mod:AddCallback(ModCallbacks.MC_PRE_ITEM_PICKUP, function(_, pickupPlayer, itemType)
    local player = Isaac.GetPlayer(0)
    if not player then return end

    local isActive = false
    local itemConfig = Isaac.GetItemConfig()
    local itemData = itemConfig:GetCollectible(itemType)
    if itemData then
        isActive = itemData.Type == ItemType.ITEM_ACTIVE
    end

    local cost = isActive and 10 or 5

    if player:GetNumCoins() < cost then
        Isaac.DebugString(string.format("Not enough coins! Need %d for this item.", cost))
        return false  -- Prevent pickup
    end

    player:AddCoins(-cost)
    Isaac.DebugString(string.format("Paid %d coins for item. Remaining: %d",
        cost, player:GetNumCoins()))
end)

Isaac.DebugString("Item Tax loaded!")
