-- =============================================================================
--  CancerTrinketTears - The Binding of Isaac: Repentance
--  Cancer trinket also removes the tear delay cap
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CancerTrinketTears", 1)
local TRINKET_CANCER = 39

function mod:onCacheUpdate(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        if player:HasTrinket(TRINKET_CANCER) then
            player.MaxFireDelay = 0
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCacheUpdate)
Isaac.DebugString("CancerTrinketTears loaded!")
