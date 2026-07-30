-- =============================================================================
--  GuppyTransformationBuff - The Binding of Isaac: Repentance
--  Guppy transformation also grants +1 damage and spectral tears
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GuppyTransformationBuff", 1)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if player:GetPlayerType() == PlayerType.PLAYER_GUPPY then
        if cacheFlag & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage + 1.0
        end
        if cacheFlag & CacheFlag.CACHE_TEARFLAG == CacheFlag.CACHE_TEARFLAG then
            player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if player:GetPlayerType() == PlayerType.PLAYER_GUPPY then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_TEARFLAG)
    end
end)

Isaac.DebugString("GuppyTransformationBuff loaded!")
