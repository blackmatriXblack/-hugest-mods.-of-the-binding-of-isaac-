-- =============================================================================
--  ConjoinedTransformation - The Binding of Isaac: Repentance
--  Conjoined transformation fires +50% faster instead of just 3-way shot
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ConjoinedTransformation", 1)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if cacheFlag & CacheFlag.CACHE_FIREDELAY ~= CacheFlag.CACHE_FIREDELAY then return end
    if player:GetPlayerType() == PlayerType.PLAYER_CAIN then return end
    -- Conjoined check: player has transformation via familiar count
    local familiarCount = 0
    for i = 0, 100 do
        local fam = player:GetFamiliarByIndex(i)
        if fam and fam.Type == FamiliarVariant.BROTHER_BOBBY then
            familiarCount = familiarCount + 1
        end
    end
    -- Alternative: use HasCollectible checks for conjoined items
    local conjoinedItems = {
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
        CollectibleType.COLLECTIBLE_POLY_BABY,
    }
    local count = 0
    for _, id in ipairs(conjoinedItems) do
        if player:HasCollectible(id) then count = count + 1 end
    end
    if count >= 3 then
        player.MaxFireDelay = player.MaxFireDelay * 2 / 3
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    local conjoinedItems = {
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
        CollectibleType.COLLECTIBLE_POLY_BABY,
    }
    local count = 0
    for _, id in ipairs(conjoinedItems) do
        if player:HasCollectible(id) then count = count + 1 end
    end
    if count >= 3 then
        player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
    end
end)

Isaac.DebugString("ConjoinedTransformation loaded!")
