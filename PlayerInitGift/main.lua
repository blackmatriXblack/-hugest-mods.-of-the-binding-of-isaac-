-- =============================================================================
--  PlayerInitGift — The Binding of Isaac: Repentance
--  New characters start with a random shop item pool item.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PlayerInitGift", 1)

function mod:onPlayerInit(player)
    if player then
        local itemPool = Game():GetItemPool()
        local shopItem = itemPool:GetCollectible(ItemPoolType.POOL_SHOP)
        if shopItem and shopItem ~= CollectibleType.COLLECTIBLE_NULL then
            player:AddCollectible(shopItem, 0, false)
            Isaac.DebugString("PlayerInitGift: Granted shop item #" .. tostring(shopItem))
            -- Remove the item from pools so it can still appear naturally
            itemPool:RemoveCollectible(shopItem)
            itemPool:AddRoomBlacklist(shopItem)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.onPlayerInit)
Isaac.DebugString("PlayerInitGift loaded!")
