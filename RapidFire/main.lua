-- RapidFire: Sets fire delay to minimum for fastest possible fire rate
local mod = RegisterMod("RapidFire", 1)

function mod:onCacheUpdate(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = 1
    end
end

function mod:onPEffectUpdate(player)
    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
    player:EvaluateItems()
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCacheUpdate)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
Isaac.DebugString("RapidFire loaded! Fire delay set to minimum.")
