-- =============================================================================
--  ForgottenBoneSwing - The Binding of Isaac: Repentance
--  The Forgotten's bone club deals 2x damage on melee swing.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ForgottenBoneSwing", 1)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
        -- Boost damage while in bone club (melee) form
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    end
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE
       and player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
        -- Double damage for the bone club swing
        player.Damage = player.Damage * 2
    end
end)

Isaac.DebugString("ForgottenBoneSwing loaded!")
