-- ==========================================================================
--  Escalating Damage - The Binding of Isaac: Repentance
--  Player damage increases +10% per room cleared but HP decreases 1% per room
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("EscalatingDamage", 1)
local game = Game()
local roomsCleared = 0
local baseDamage = 3.5

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    roomsCleared = roomsCleared + 1

    for p = 0, game:GetNumPlayers() - 1 do
        local player = game:GetPlayer(p)
        if not player then break end

        -- Increase damage by 10% per room
        local dmgMultiplier = 1 + (roomsCleared * 0.1)
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

        -- Decrease HP by 1% per room (minimum 1 half heart)
        local maxHP = player:GetMaxHearts()
        local hpHit = math.max(1, math.floor(maxHP * 0.01 * roomsCleared * 2) / 2)
        local newMax = math.max(1, maxHP - hpHit)
        player:AddMaxHearts(-hpHit, true)
    end
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = baseDamage * (1 + roomsCleared * 0.1)
    end
end)

-- Show current multiplier
mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    Isaac.RenderText(string.format("Room %d | Dmg x%.1f",
        roomsCleared, 1 + roomsCleared * 0.1),
        60, 80, 0.8, 1, 0.3, 0.3)
end)

Isaac.DebugString("Escalating Damage loaded!")
