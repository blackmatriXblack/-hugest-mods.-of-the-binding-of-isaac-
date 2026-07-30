-- =============================================================================
--  FamiliarArmy - The Binding of Isaac: Repentance
--  Every 3 familiars owned grant +1 damage
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FamiliarArmy", 1)

local familiarItems = {
    CollectibleType.COLLECTIBLE_BROTHER_BOBBY,
    CollectibleType.COLLECTIBLE_SISTER_MAGGY,
    CollectibleType.COLLECTIBLE_LIL_CHUBBY,
    CollectibleType.COLLECTIBLE_LIL_GISH,
    CollectibleType.COLLECTIBLE_MONGO_BABY,
    CollectibleType.COLLECTIBLE_HARLEQUIN_BABY,
    CollectibleType.COLLECTIBLE_LIL_LOKI,
    CollectibleType.COLLECTIBLE_LIL_CHAD,
    CollectibleType.COLLECTIBLE_LIL_GURDY,
    CollectibleType.COLLECTIBLE_ROBO_BABY,
    CollectibleType.COLLECTIBLE_ROBO_BABY_2,
    CollectibleType.COLLECTIBLE_LITTLE_STEVEN,
    CollectibleType.COLLECTIBLE_DEMON_BABY,
    CollectibleType.COLLECTIBLE_LIL_BRIMSTONE,
    CollectibleType.COLLECTIBLE_GHOST_BABY,
    CollectibleType.COLLECTIBLE_LIL_HAUNT,
    CollectibleType.COLLECTIBLE_FORETOLD_BABY,
    CollectibleType.COLLECTIBLE_SERAPHIM,
    CollectibleType.COLLECTIBLE_INCUBUS,
    CollectibleType.COLLECTIBLE_SUCCUBUS,
    CollectibleType.COLLECTIBLE_LIL_DELIRIUM,
    CollectibleType.COLLECTIBLE_BUMBO,
    CollectibleType.COLLECTIBLE_DRY_BABY,
    CollectibleType.COLLECTIBLE_DARK_BUM,
    CollectibleType.COLLECTIBLE_KEY_BUM,
    CollectibleType.COLLECTIBLE_RUNE_BAG,
    CollectibleType.COLLECTIBLE_KING_BABY,
    CollectibleType.COLLECTIBLE_BIG_CHUBBY,
    CollectibleType.COLLECTIBLE_SACK_OF_PENNIES,
    CollectibleType.COLLECTIBLE_LIL_SPEWER,
    CollectibleType.COLLECTIBLE_POLYCEPHALUS_BABY,
    CollectibleType.COLLECTIBLE_BLOOD_BABY,
    CollectibleType.COLLECTIBLE_ANGRY_FLY,
    CollectibleType.COLLECTIBLE_BIG_FAN,
    CollectibleType.COLLECTIBLE_SISSY_LONGLEGS,
    CollectibleType.COLLECTIBLE_THE_SOUL,
    CollectibleType.COLLECTIBLE_PUNCHING_BAG,
    CollectibleType.COLLECTIBLE_FATES_REWARD,
    CollectibleType.COLLECTIBLE_LIL_CHEST,
    CollectibleType.COLLECTIBLE_LEECH,
    CollectibleType.COLLECTIBLE_BBF,
    CollectibleType.COLLECTIBLE_BEST_BUD,
}

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if cacheFlag & CacheFlag.CACHE_DAMAGE ~= CacheFlag.CACHE_DAMAGE then return end
    local count = 0
    for _, id in ipairs(familiarItems) do
        if player:HasCollectible(id) then count = count + 1 end
    end
    local bonus = math.floor(count / 3)
    if bonus > 0 then
        player.Damage = player.Damage + bonus
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
end)

Isaac.DebugString("FamiliarArmy loaded!")
