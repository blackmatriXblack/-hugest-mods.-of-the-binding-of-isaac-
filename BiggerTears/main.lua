-- =============================================================================
--  BIGGER TEARS — The Binding of Isaac: Repentance
--  Multiplies tear size: TearHeight and TearFallingSpeed x3.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BiggerTears", 1)

function mod:onPEffectUpdate(player)
    if player == nil then return end
    player:AddCacheFlags(2) -- CacheFlag.CACHE_DAMAGE = 2
    player:AddCacheFlags(16) -- CacheFlag.CACHE_FIREDELAY = 16
    player:EvaluateItems()
end

function mod:onCache(player, cacheFlag)
    if cacheFlag == 2 then -- CacheFlag.CACHE_DAMAGE
        player.TearHeight = player.TearHeight * 3
        player.TearFallingSpeed = player.TearFallingSpeed * 3
    end
    if cacheFlag == 16 then -- CacheFlag.CACHE_FIREDELAY
        player.TearHeight = player.TearHeight * 3
        player.TearFallingSpeed = player.TearFallingSpeed * 3
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCache)
Isaac.DebugString("Bigger Tears loaded!")
