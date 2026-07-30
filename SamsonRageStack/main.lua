-- =============================================================================
--  SamsonRageStack - The Binding of Isaac: Repentance
--  Samson's Bloody Lust damage bonus cap increases to +15.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SamsonRageStack", 1)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if player:GetPlayerType() == PlayerType.PLAYER_SAMSON then
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    end
end)

-- Extend Bloody Lust damage cap by tracking floor kills
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE
       and player:GetPlayerType() == PlayerType.PLAYER_SAMSON then
        -- Bloody Lust base bonus stacks per kill; extend the cap to +15
        local currentFloor = Game():GetLevel():GetStage()
        local extra = math.min(currentFloor * 2, 8) -- up to +8 extra atop base +7
        player.Damage = player.Damage + extra
    end
end)

Isaac.DebugString("SamsonRageStack loaded!")
