-- =============================================================================
--  MomItemsSetBonus - The Binding of Isaac: Repentance
--  Having 5+ Mom items grants +3 damage
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MomItemsSetBonus", 1)

local momItems = {
    CollectibleType.COLLECTIBLE_MOMS_KNIFE,
    CollectibleType.COLLECTIBLE_MOMS_HEELS,
    CollectibleType.COLLECTIBLE_MOMS_LIPSTICK,
    CollectibleType.COLLECTIBLE_MOMS_UNDERWEAR,
    CollectibleType.COLLECTIBLE_MOMS_BRA,
    CollectibleType.COLLECTIBLE_MOMS_PAD,
    CollectibleType.COLLECTIBLE_MOMS_EYE,
    CollectibleType.COLLECTIBLE_MOMS_CONTACTS,
    CollectibleType.COLLECTIBLE_MOMS_PERFUME,
    CollectibleType.COLLECTIBLE_MOMS_BOTTLE_OF_PILLS,
    CollectibleType.COLLECTIBLE_MOMS_PEARLS,
    CollectibleType.COLLECTIBLE_MOMS_PURSE,
    CollectibleType.COLLECTIBLE_MOMS_KEY,
    CollectibleType.COLLECTIBLE_MOMS_RAZOR,
    CollectibleType.COLLECTIBLE_MOMS_WIG,
    CollectibleType.COLLECTIBLE_MOMS_RING,
    CollectibleType.COLLECTIBLE_MOMS_SHOVEL,
    CollectibleType.COLLECTIBLE_MOMS_COIN_PURSE,
    CollectibleType.COLLECTIBLE_MOMS_BOX,
}

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if cacheFlag & CacheFlag.CACHE_DAMAGE ~= CacheFlag.CACHE_DAMAGE then return end
    local count = 0
    for _, id in ipairs(momItems) do
        if player:HasCollectible(id) then count = count + 1 end
    end
    if count >= 5 then
        player.Damage = player.Damage + 3.0
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    local count = 0
    for _, id in ipairs(momItems) do
        if player:HasCollectible(id) then count = count + 1 end
    end
    if count >= 5 then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    end
end)

Isaac.DebugString("MomItemsSetBonus loaded!")
