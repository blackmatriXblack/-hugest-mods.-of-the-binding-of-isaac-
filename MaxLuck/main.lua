-- MaxLuck: Sets player luck to 99 for maximum luck on everything
local mod = RegisterMod("MaxLuck", 1)

function mod:onCacheUpdate(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = 99
    end
end

function mod:onPEffectUpdate(player)
    player:AddCacheFlags(CacheFlag.CACHE_LUCK)
    player:EvaluateItems()
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCacheUpdate)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
Isaac.DebugString("MaxLuck loaded! Luck always 99.")
