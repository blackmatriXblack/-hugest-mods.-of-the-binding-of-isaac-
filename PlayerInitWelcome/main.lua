-- Welcome new player with debug message and 5 coins
local mod = RegisterMod("PlayerInitWelcome", 1)
local game = Game()

function mod:onPlayerInit(player)
    if player then
        Isaac.DebugString("New player spawned!")
        player:AddCoins(5)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.onPlayerInit)
Isaac.DebugString("PlayerInitWelcome loaded! Welcomes new players with 5 coins.")
