-- =============================================================================
--  EveWhoreMode - The Binding of Isaac: Repentance
--  Eve gets Whore of Babylon damage bonus even at full red health.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("EveWhoreMode", 1)

-- Re-evaluate cache each frame so Whore bonus is always active
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if player:GetPlayerType() == PlayerType.PLAYER_EVE then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    end
end)

-- Apply bonus damage if Whore of Babylon is not naturally active
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE
       and player:GetPlayerType() == PlayerType.PLAYER_EVE then
        if not player:HasPlayerForm(PlayerForm.PLAYERFORM_WHORE) then
            player.Damage = player.Damage + 1.5
        end
    end
end)

Isaac.DebugString("EveWhoreMode loaded!")
