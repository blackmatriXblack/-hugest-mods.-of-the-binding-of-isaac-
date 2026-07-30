-- =============================================================================
--  BerserkStartBuff — The Binding of Isaac: Repentance
--  MC_PRE_BERSERK: On berserk start (eg. Berserk card), player also gains
--  flight and spectral tears for the duration. Uses cache flags.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BerserkStartBuff", 1)

local BERSERK_ACTIVE = {}

function mod:onPreBerserk(player, isBeserk)
    if not player:Exists() then return end
    if not isBeserk then return nil end

    local idx = GetPtrHash(player)
    BERSERK_ACTIVE[idx] = true

    -- Grant flight and spectral tears for the duration
    player:AddCacheFlags(CacheFlag.CACHE_FLYING)
    player:AddCacheFlags(CacheFlag.CACHE_TEARFLAG)
    player:EvaluateItems()
end
mod:AddCallback(ModCallbacks.MC_PRE_BERSERK, mod.onPreBerserk)

function mod:onEvaluateCache(player, cacheFlag)
    if not player:Exists() then return end
    local idx = GetPtrHash(player)

    if BERSERK_ACTIVE[idx] then
        if cacheFlag == CacheFlag.CACHE_FLYING then
            player.CanFly = true
        elseif cacheFlag == CacheFlag.CACHE_TEARFLAG then
            player.TearFlags = player.TearFlags | TearFlags.TEAR_SPECTRAL
        end
    end
end
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onEvaluateCache)

-- Clean up after berserk ends (linked to PostBerserk)
-- This mod only adds buffs on start; BerserkEndExplosion handles the aftermath

Isaac.DebugString("BerserkStartBuff loaded!")
