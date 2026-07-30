-- AllStatsBoost: Doubles all player stats
local mod = RegisterMod("AllStatsBoost", 1)

function mod:onCacheUpdate(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage * 2
    end
    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        player.MaxFireDelay = player.MaxFireDelay * 0.5
    end
    if cacheFlag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed * 2
    end
    if cacheFlag == CacheFlag.CACHE_RANGE then
        player.TearHeight = player.TearHeight * 2
    end
    if cacheFlag == CacheFlag.CACHE_SHOTSPEED then
        player.ShotSpeed = player.ShotSpeed * 2
    end
    if cacheFlag == CacheFlag.CACHE_LUCK then
        player.Luck = player.Luck * 2
    end
end

function mod:onPEffectUpdate(player)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE + CacheFlag.CACHE_FIREDELAY + CacheFlag.CACHE_SPEED + CacheFlag.CACHE_RANGE + CacheFlag.CACHE_SHOTSPEED + CacheFlag.CACHE_LUCK)
    player:EvaluateItems()
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCacheUpdate)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
Isaac.DebugString("AllStatsBoost loaded! All stats doubled.")
