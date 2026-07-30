-- =============================================================================
--  YesMotherTransformation - The Binding of Isaac: Repentance
--  Yes Mother? transformation gives +1.5 damage and charm tears
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("YesMotherTransformation", 1)

local motherItems = {
    CollectibleType.COLLECTIBLE_MOMS_HEELS,
    CollectibleType.COLLECTIBLE_MOMS_LIPSTICK,
    CollectibleType.COLLECTIBLE_MOMS_UNDERWEAR,
    CollectibleType.COLLECTIBLE_MOMS_BRA,
    CollectibleType.COLLECTIBLE_MOMS_PAD,
}

local function isYesMother(player)
    local count = 0
    for _, id in ipairs(motherItems) do
        if player:HasCollectible(id) then count = count + 1 end
    end
    return count >= 3
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if not isYesMother(player) then return end
    if cacheFlag & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + 1.5
    end
    if cacheFlag & CacheFlag.CACHE_TEARFLAG == CacheFlag.CACHE_TEARFLAG then
        player.TearFlags = player.TearFlags | TearFlags.TEAR_CHARM
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if isYesMother(player) then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_TEARFLAG)
    end
end)

Isaac.DebugString("YesMotherTransformation loaded!")
