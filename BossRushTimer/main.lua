-- BossRushTimer: Displays game time and Boss Rush countdown on HUD
local mod = RegisterMod("BossRushTimer", 1)

function mod:onRender()
    local game = Game()
    local totalSeconds = game:GetFrameCount() / 60
    local totalMinutes = totalSeconds / 60
    local timeStr = string.format("Time: %.0f min %.0f sec", totalMinutes, totalSeconds % 60)
    Isaac.RenderText(timeStr, 10, 10, 255, 255, 255, 255, 2)
    if totalMinutes < 20 then
        local remaining = math.floor(20 - totalMinutes)
        Isaac.RenderText("Boss Rush in: " .. remaining .. " min", 10, 30, 255, 200, 0, 255, 2)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("BossRushTimer loaded! Displaying game time on HUD.")
