-- When player character changes, give bonus items and log it
local mod = RegisterMod("PlayerChangeMod", 1)
local game = Game()

function mod:onPlayerChange(player)
    if player then
        local playerType = player:GetPlayerType()
        Isaac.DebugString("Player changed! New type: " .. tostring(playerType))
        -- Give bonus items: Add keys, bombs, coins
        player:AddKeys(2)
        player:AddBombs(2)
        player:AddCoins(10)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_CHANGE, mod.onPlayerChange)
Isaac.DebugString("PlayerChangeMod loaded! Gives bonus items on player character change.")
