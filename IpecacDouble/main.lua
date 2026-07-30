-- =============================================================================
--  Ipecac Double - The Binding of Isaac: Repentance
--  Ipecac (149) adds +5 flat damage instead of +40% damage.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("IpecacDouble", 1)
local COLLECTIBLE_IPECAC = 149
local FLAT_DAMAGE_IPECAC = 5.0

function mod:OnCacheEval(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        if player:HasCollectible(COLLECTIBLE_IPECAC) then
            -- Replaces percentage bonus with flat +5 damage
            player.Damage = player.Damage + FLAT_DAMAGE_IPECAC
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnCacheEval)
Isaac.DebugString("IpecacDouble loaded!")
