local mod = RegisterMod("VictoryLapTracker", 1)
local game = Game()

function mod:onRender()
    local lap = game:GetVictoryLap()
    Isaac.RenderText("Victory Lap: " .. lap, 10, 32, 1, 1, 0.7, 0.2, 1)
end

mod:AddCallback(4, mod.onRender) -- MC_POST_RENDER
Isaac.DebugString("VictoryLapTracker: Displays victory lap count on HUD!")
