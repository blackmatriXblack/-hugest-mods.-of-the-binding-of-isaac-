-- =============================================================================
--  DAMAGE MULTIPLIER — The Binding of Isaac: Repentance
--  Multiply your damage by 10x. Destroy everything!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DamageMultiplier", 1)

function mod:onPEffectUpdate(player)
    if player == nil then return end
    player:AddCacheFlags(2) -- CacheFlag.CACHE_DAMAGE
    player:EvaluateItems()
end

function mod:onCache(player, cacheFlag)
    if cacheFlag == 2 then
        player.Damage = player.Damage * 10
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCache)
Isaac.DebugString("Damage Multiplier loaded! 10x damage.")
