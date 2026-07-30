local mod = RegisterMod("PlayerDeathReward", 1)
local game = Game()

function mod:onGameEnd()
    Isaac.DebugString("Player death logged - Game ended!")
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_END, mod.onGameEnd)
