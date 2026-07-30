-- =============================================================================
--  LeviathanTransformation - The Binding of Isaac: Repentance
--  Leviathan transformation grants brimstone immunity and flight
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("LeviathanTransformation", 1)

local leviathanItems = {
    CollectibleType.COLLECTIBLE_BRIMSTONE,
    CollectibleType.COLLECTIBLE_NAIL,
    CollectibleType.COLLECTIBLE_MARK,
    CollectibleType.COLLECTIBLE_ABADDON,
    CollectibleType.COLLECTIBLE_PENTAGRAM,
    CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT,
    CollectibleType.COLLECTIBLE_SPIRIT_OF_THE_NIGHT,
    CollectibleType.COLLECTIBLE_DEATHS_TOUCH,
    CollectibleType.COLLECTIBLE_MAW_OF_THE_VOID,
}

local function isLeviathan(player)
    local count = 0
    for _, id in ipairs(leviathanItems) do
        if player:HasCollectible(id) then count = count + 1 end
    end
    return count >= 3
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if not isLeviathan(player) then return end
    if cacheFlag & CacheFlag.CACHE_FLYING == CacheFlag.CACHE_FLYING then
        player.CanFly = true
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if isLeviathan(player) then
        player:AddCacheFlags(CacheFlag.CACHE_FLYING)
    end
end)

Isaac.DebugString("LeviathanTransformation loaded!")
