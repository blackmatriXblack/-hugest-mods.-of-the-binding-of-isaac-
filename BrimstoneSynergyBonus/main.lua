-- =============================================================================
--  BrimstoneSynergyBonus - The Binding of Isaac: Repentance
--  Brimstone + any damage item adds +2 bonus damage
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BrimstoneSynergyBonus", 1)
local game = Game()

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if cacheFlag & CacheFlag.CACHE_DAMAGE ~= CacheFlag.CACHE_DAMAGE then return end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
        local damageItems = 0
        local itemList = {
            CollectibleType.COLLECTIBLE_GROWTH_HORMONES,
            CollectibleType.COLLECTIBLE_STEROIDS,
            CollectibleType.COLLECTIBLE_BLOOD_OF_THE_MARTYR,
            CollectibleType.COLLECTIBLE_STIGMATA,
            CollectibleType.COLLECTIBLE_CRICKETS_HEAD,
            CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM,
            CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT,
            CollectibleType.COLLECTIBLE_SACRED_HEART,
            CollectibleType.COLLECTIBLE_POLYPHEMUS,
            CollectibleType.COLLECTIBLE_EVE_MASCARA,
            CollectibleType.COLLECTIBLE_PROPTOSIS,
            CollectibleType.COLLECTIBLE_IMMACULATE_CONCEPTION,
        }
        for _, id in ipairs(itemList) do
            if player:HasCollectible(id) then damageItems = damageItems + 1 end
        end
        if damageItems > 0 then
            player.Damage = player.Damage + 2.0
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    end
end)

Isaac.DebugString("BrimstoneSynergyBonus loaded!")
