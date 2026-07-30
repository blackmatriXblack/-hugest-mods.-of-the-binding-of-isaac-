-- =============================================================================
--  BobTransformation - The Binding of Isaac: Repentance
--  Bob transformation grants poison immunity and +1 damage per poison-related item
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BobTransformation", 1)

local poisonItems = {
    CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD,
    CollectibleType.COLLECTIBLE_BOBS_CURSE,
    CollectibleType.COLLECTIBLE_IPECAC,
    CollectibleType.COLLECTIBLE_SCORPIO,
    CollectibleType.COLLECTIBLE_THE_VIRUS,
    CollectibleType.COLLECTIBLE_COMMON_COLD,
    CollectibleType.COLLECTIBLE_SERPENTS_KISS,
    CollectibleType.COLLECTIBLE_POISON_MUSHROOM,
    CollectibleType.COLLECTIBLE_TOXIC_SHOCK,
    CollectibleType.COLLECTIBLE_CONTAGION,
}

local bobItems = {
    CollectibleType.COLLECTIBLE_BOBS_ROTTEN_HEAD,
    CollectibleType.COLLECTIBLE_BOBS_CURSE,
    CollectibleType.COLLECTIBLE_BOBS_BRAIN,
}

local function isBob(player)
    local count = 0
    for _, id in ipairs(bobItems) do
        if player:HasCollectible(id) then count = count + 1 end
    end
    return count >= 3
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if cacheFlag & CacheFlag.CACHE_DAMAGE ~= CacheFlag.CACHE_DAMAGE then return end
    if isBob(player) then
        local poisonCount = 0
        for _, id in ipairs(poisonItems) do
            if player:HasCollectible(id) then poisonCount = poisonCount + 1 end
        end
        player.Damage = player.Damage + poisonCount
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if isBob(player) then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        -- Poison immunity via Callus effect
        if player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_CALLUS) == 0 then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_CALLUS, false, 1)
        end
    end
end)

Isaac.DebugString("BobTransformation loaded!")
