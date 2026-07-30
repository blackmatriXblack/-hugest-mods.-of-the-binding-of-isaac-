-- On each new floor, gain 2 Eternal Hearts
local mod = RegisterMod("EternalHeartGain", 1)
local game = Game()

function mod:onNewLevel()
    local player = Isaac.GetPlayer(0)
    player:AddEternalHearts(2)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
Isaac.DebugString("EternalHeartGain loaded! Gain 2 Eternal Hearts each new floor.")
