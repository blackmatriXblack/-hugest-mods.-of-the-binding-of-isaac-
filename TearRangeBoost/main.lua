-- Multiply tear range by 5 (CACHE_RANGE = 4)
local mod = RegisterMod("TearRangeBoost", 1)
local game = Game()

function mod:onPEffectUpdate(player, cacheFlags)
    if cacheFlags & 4 == 4 then  -- CacheFlag.CACHE_RANGE
        player.TearRange = player.TearRange * 5
    end
end

function mod:onNewRoom()
    local player = Isaac.GetPlayer(0)
    if player then
        player:AddCacheFlags(4)
        player:EvaluateItems()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("TearRangeBoost loaded! Tear range multiplied by 5.")
