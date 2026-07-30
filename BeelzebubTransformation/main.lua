-- =============================================================================
--  BeelzebubTransformation - The Binding of Isaac: Repentance
--  Beelzebub (Lord of the Flies) transformation also grants +0.5 speed and poison immunity
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BeelzebubTransformation", 1)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if player:GetPlayerType() ~= PlayerType.PLAYER_BLACK_JUDAS then return end
    if cacheFlag & CacheFlag.CACHE_SPEED == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + 0.5
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if player:GetPlayerType() == PlayerType.PLAYER_BLACK_JUDAS then
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
    end
end)

Isaac.DebugString("BeelzebubTransformation loaded!")
