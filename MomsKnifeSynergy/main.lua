-- =============================================================================
--  MomsKnifeSynergy - The Binding of Isaac: Repentance
--  Mom's Knife + any tear modifier adds spectral properties
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MomsKnifeSynergy", 1)

local tearModifiers = {
    CollectibleType.COLLECTIBLE_CUPIDS_ARROW,
    CollectibleType.COLLECTIBLE_WIGGLE_WORM,
    CollectibleType.COLLECTIBLE_RING_WORM,
    CollectibleType.COLLECTIBLE_HOOK_WORM,
    CollectibleType.COLLECTIBLE_FLAT_WORM,
    CollectibleType.COLLECTIBLE_OUROBOROS_WORM,
    CollectibleType.COLLECTIBLE_TAPE_WORM,
    CollectibleType.COLLECTIBLE_LAZY_WORM,
    CollectibleType.COLLECTIBLE_PULSE_WORM,
    CollectibleType.COLLECTIBLE_MY_REFLECTION,
    CollectibleType.COLLECTIBLE_SPOON_BENDER,
    CollectibleType.COLLECTIBLE_LOST_CONTACT,
    CollectibleType.COLLECTIBLE_DEAD_EYE,
    CollectibleType.COLLECTIBLE_TRISAGION,
    CollectibleType.COLLECTIBLE_GODHEAD,
    CollectibleType.COLLECTIBLE_PARASITE,
    CollectibleType.COLLECTIBLE_CRICKETS_BODY,
    CollectibleType.COLLECTIBLE_COMPOUND_FRACTURE,
    CollectibleType.COLLECTIBLE_EYE_OF_BELIAL,
    CollectibleType.COLLECTIBLE_LOKIS_HORNS,
    CollectibleType.COLLECTIBLE_MOMS_EYE,
}

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if cacheFlag & CacheFlag.CACHE_TEARFLAG ~= CacheFlag.CACHE_TEARFLAG then return end
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
        local hasModifier = false
        for _, id in ipairs(tearModifiers) do
            if player:HasCollectible(id) then hasModifier = true; break end
        end
        if hasModifier then
            player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if player:HasCollectible(CollectibleType.COLLECTIBLE_MOMS_KNIFE) then
        player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
    end
end)

Isaac.DebugString("MomsKnifeSynergy loaded!")
