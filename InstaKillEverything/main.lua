-- =============================================================================
--  INSTA KILL EVERYTHING — The Binding of Isaac: Repentance
--  Your tears deal 99999 damage. One shot, one kill.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("InstaKillEverything", 1)

function mod:onPEffectUpdate(player)
    if player == nil then return end
    player:AddCacheFlags(2) -- CacheFlag.CACHE_DAMAGE = 2
    player:EvaluateItems()
end

function mod:onCache(player, cacheFlag)
    if cacheFlag == 2 then -- CacheFlag.CACHE_DAMAGE
        player.Damage = 99999
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCache)
Isaac.DebugString("Insta Kill Everything loaded! Tears deal 99999 damage.")
