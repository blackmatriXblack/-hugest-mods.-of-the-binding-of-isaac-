-- =============================================================================
--  Cricket's Head Percent - The Binding of Isaac: Repentance
--  Cricket's Head (4) adds +1.5 flat damage instead of +0.5.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CricketHeadPercent", 1)
local COLLECTIBLE_CRICKETS_HEAD = 4
local FLAT_DAMAGE_BONUS = 1.5

function mod:OnCacheEval(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        if player:HasCollectible(COLLECTIBLE_CRICKETS_HEAD) then
            player.Damage = player.Damage + FLAT_DAMAGE_BONUS
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnCacheEval)
Isaac.DebugString("CricketHeadPercent loaded!")
