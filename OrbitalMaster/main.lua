-- =============================================================================
--  OrbitalMaster - The Binding of Isaac: Repentance
--  Every 2 orbitals grant +1 damage and +0.5 tears
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("OrbitalMaster", 1)

local orbitalItems = {
    CollectibleType.COLLECTIBLE_CUBE_OF_MEAT,
    CollectibleType.COLLECTIBLE_BALL_OF_BANDAGES,
    CollectibleType.COLLECTIBLE_SACRIFICIAL_DAGGER,
    CollectibleType.COLLECTIBLE_GUARDIAN_ANGEL,
    CollectibleType.COLLECTIBLE_BIG_FAN,
    CollectibleType.COLLECTIBLE_FOREVER_ALONE,
    CollectibleType.COLLECTIBLE_DISTANT_ADMIRATION,
    CollectibleType.COLLECTIBLE_FRIEND_ZONE,
    CollectibleType.COLLECTIBLE_LOST_SOUL,
    CollectibleType.COLLECTIBLE_SISSY_LONGLEGS,
    CollectibleType.COLLECTIBLE_PRETTY_FLY,
    CollectibleType.COLLECTIBLE_RING_OF_FLIES,
    CollectibleType.COLLECTIBLE_BEST_BUD,
    CollectibleType.COLLECTIBLE_SWORN_PROTECTOR,
    CollectibleType.COLLECTIBLE_FLY_ORBITAL,
    CollectibleType.COLLECTIBLE_DRY_BABY,
    CollectibleType.COLLECTIBLE_DARK_BUM,
    CollectibleType.COLLECTIBLE_PUNCHING_BAG,
}

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    local count = 0
    for _, id in ipairs(orbitalItems) do
        if player:HasCollectible(id) then count = count + 1 end
    end
    local bonus = math.floor(count / 2)
    if bonus <= 0 then return end

    if cacheFlag & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + bonus
    end
    if cacheFlag & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = player.MaxFireDelay - bonus
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_FIREDELAY)
end)

Isaac.DebugString("OrbitalMaster loaded!")
