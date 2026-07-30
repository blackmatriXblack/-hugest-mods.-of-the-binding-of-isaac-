local mod = RegisterMod("TearFearChance", 1)

function mod:onPeffectUpdate(player, flags)
    player.TearFearChance = 40
end

function mod:onEvaluateCache(player, flags)
    if flags & CacheFlag.CACHE_TEARFLAG ~= 0 then
        player.TearFearChance = 40
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPeffectUpdate)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onEvaluateCache)
