-- SniperShots: Multiplies shot speed by 5 for very fast projectiles
local mod = RegisterMod("SniperShots", 1)

function mod:onCacheUpdate(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed * 5
    end
end

function mod:onPEffectUpdate(player)
    player:AddCacheFlags(CacheFlag.CACHE_SHOTSPEED)
    player:EvaluateItems()
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCacheUpdate)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
Isaac.DebugString("SniperShots loaded! Shot speed multiplied by 5.")
