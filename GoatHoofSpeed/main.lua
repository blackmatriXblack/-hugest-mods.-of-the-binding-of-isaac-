-- =============================================================================
--  GoatHoofSpeed - The Binding of Isaac: Repentance
--  Goat Hoof trinket gives +0.5 speed (up from +0.15)
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GoatHoofSpeed", 1)
local TRINKET_GOAT_HOOF = 12

function mod:onCacheUpdate(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_SPEED then
        if player:HasTrinket(TRINKET_GOAT_HOOF) then
            player.MoveSpeed = player.MoveSpeed + 0.35
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCacheUpdate)
Isaac.DebugString("GoatHoofSpeed loaded!")
