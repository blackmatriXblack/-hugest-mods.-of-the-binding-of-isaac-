-- =============================================================================
--  Soy Milk Buff - The Binding of Isaac: Repentance
--  Soy Milk (330) damage penalty reduced from -80% to -50%.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SoyMilkBuff", 1)
local COLLECTIBLE_SOY_MILK = 330
local SOY_MILK_DAMAGE_RATIO = 0.5  -- 50% damage instead of 20%

function mod:OnCacheEval(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        if player:HasCollectible(COLLECTIBLE_SOY_MILK) then
            player.Damage = player.Damage * (SOY_MILK_DAMAGE_RATIO / 0.2)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnCacheEval)
Isaac.DebugString("SoyMilkBuff loaded!")
