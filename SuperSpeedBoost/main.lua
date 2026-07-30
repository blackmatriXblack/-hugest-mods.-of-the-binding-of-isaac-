-- =============================================================================
--  SUPER SPEED BOOST — The Binding of Isaac: Repentance
--  Triple movement speed. Zoom through rooms!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SuperSpeedBoost", 1)

function mod:onPEffectUpdate(player)
    if player == nil then return end
    player:AddCacheFlags(32) -- CacheFlag.CACHE_SPEED = 32
    player:EvaluateItems()
end

function mod:onCache(player, cacheFlag)
    if cacheFlag == 32 then
        player.MoveSpeed = player.MoveSpeed * 3
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCache)
Isaac.DebugString("Super Speed Boost loaded! 3x movement speed.")
