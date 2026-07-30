local mod = RegisterMod("GameEndLogger", 1)
local game = Game()

function mod:onGameEnd()
    Isaac.DebugString("Game ended!")
    local player = Isaac.GetPlayer(0)
    Isaac.DebugString("Final stats - Keys: " .. tostring(player:GetNumKeys()) .. " Bombs: " .. tostring(player:GetNumBombs()) .. " Coins: " .. tostring(player:GetNumCoins()))
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_END, mod.onGameEnd)
