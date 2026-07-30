-- ==========================================================================
--  Active Item Only Challenge - The Binding of Isaac: Repentance
--  Active item charges fully every 3 seconds but tears deal zero damage
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("ActiveItemOnlyChallenge", 1)
local game = Game()
local frameCounter = 0

-- Zero out tear damage and rapid charge active item
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    -- Tears deal zero damage
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    frameCounter = frameCounter + 1

    -- Every 3 seconds (90 frames at 30fps), fully charge active item
    if frameCounter % 90 == 0 then
        local activeItem = player:GetActiveItem()
        if activeItem ~= CollectibleType.COLLECTIBLE_NULL then
            player:SetActiveCharge(999)
        end
    end
end)

-- Override damage cache to keep tears at 0
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = 0
    end
end)

-- Prevent using regular tears for damage
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    tear.CollisionDamage = 0
end)

Isaac.DebugString("Active Item Only Challenge loaded!")
