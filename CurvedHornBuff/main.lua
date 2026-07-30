-- =============================================================================
--  CurvedHornBuff - The Binding of Isaac: Repentance
--  Curved Horn trinket gives +3 damage instead of +2
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CurvedHornBuff", 1)
local TRINKET_CURVED_HORN = 49

function mod:onCacheUpdate(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        if player:HasTrinket(TRINKET_CURVED_HORN) then
            player.Damage = player.Damage + 1.0
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCacheUpdate)
Isaac.DebugString("CurvedHornBuff loaded!")
