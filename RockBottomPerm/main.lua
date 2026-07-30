-- =============================================================================
--  Rock Bottom Perm - The Binding of Isaac: Repentance
--  Rock Bottom (558) stat boosts are 20% stronger.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RockBottomPerm", 1)
local COLLECTIBLE_ROCK_BOTTOM = 558
local STAT_BOOST_MULT = 1.2

function mod:OnCacheEval(player, cacheFlag)
    if player:HasCollectible(COLLECTIBLE_ROCK_BOTTOM) then
        -- All stat boosts during Rock Bottom are 20% stronger
        if cacheFlag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage * STAT_BOOST_MULT
        elseif cacheFlag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed * STAT_BOOST_MULT
        elseif cacheFlag == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = player.MaxFireDelay / STAT_BOOST_MULT
        elseif cacheFlag == CacheFlag.CACHE_RANGE then
            player.TearRange = player.TearRange * STAT_BOOST_MULT
        elseif cacheFlag == CacheFlag.CACHE_SHOTSPEED then
            player.ShotSpeed = player.ShotSpeed * STAT_BOOST_MULT
        elseif cacheFlag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck + 2  -- +2 luck bonus
        end
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.OnCacheEval)
Isaac.DebugString("RockBottomPerm loaded!")
