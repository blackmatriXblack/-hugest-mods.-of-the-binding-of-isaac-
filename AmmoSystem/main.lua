-- ==========================================================================
--  Ammo System - The Binding of Isaac: Repentance
--  Maximum 100 tears per room — after that tear delay becomes maxed out
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("AmmoSystem", 1)
local game = Game()
local tearsFired = 0
local AMMO_MAX = 100
local PENALTY_DELAY = 60

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    tearsFired = 0
end)

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    tearsFired = tearsFired + 1

    if tearsFired > AMMO_MAX then
        -- Remove the tear if out of ammo
        tear:Remove()
        
        for p = 0, game:GetNumPlayers() - 1 do
            local player = game:GetPlayer(p)
            if player then
                player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_FIREDELAY then
        if tearsFired > AMMO_MAX then
            player.MaxFireDelay = PENALTY_DELAY
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local remaining = math.max(0, AMMO_MAX - tearsFired)
    local color = remaining > 20 and 0.3 or 1
    Isaac.RenderText(string.format("Ammo: %d/%d", remaining, AMMO_MAX),
        55, 120, 0.7, 0.3, color, color)
end)

Isaac.DebugString("Ammo System loaded!")
