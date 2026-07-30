-- ==========================================================================
--  Bombs Only Challenge - The Binding of Isaac: Repentance
--  Player cannot fire tears — must kill everything with bombs that recharge every room
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("BombsOnlyChallenge", 1)
local game = Game()

-- Cancel all tear fire attempts
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    tear:Remove()
end)

-- Refill bombs to max on every new room
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    for p = 0, game:GetNumPlayers() - 1 do
        local player = game:GetPlayer(p)
        if player then
            player:AddBombs(99)
            -- Also give some extra bomb damage
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        end
    end
end)

-- Ensure player always has bombs available
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if player:GetNumBombs() < 5 then
        player:AddBombs(5 - player:GetNumBombs())
    end
end)

Isaac.DebugString("Bombs Only Challenge loaded!")
