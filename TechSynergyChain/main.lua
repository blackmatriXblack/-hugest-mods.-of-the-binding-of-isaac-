-- =============================================================================
--  TechSynergyChain - The Binding of Isaac: Repentance
--  Having 2+ tech items gives homing to all tech lasers
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TechSynergyChain", 1)

local techItems = {
    CollectibleType.COLLECTIBLE_TECHNOLOGY,
    CollectibleType.COLLECTIBLE_TECHNOLOGY_2,
    CollectibleType.COLLECTIBLE_TECHNOLOGY_ZERO,
    CollectibleType.COLLECTIBLE_TECH_X,
    CollectibleType.COLLECTIBLE_TECH_5,
}

local function countTechItems(player)
    local count = 0
    for _, id in ipairs(techItems) do
        if player:HasCollectible(id) then count = count + 1 end
    end
    return count
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if cacheFlag & CacheFlag.CACHE_TEARFLAG ~= CacheFlag.CACHE_TEARFLAG then return end
    if countTechItems(player) >= 2 then
        player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if countTechItems(player) >= 2 then
        player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
    end
end)

Isaac.DebugString("TechSynergyChain loaded!")
