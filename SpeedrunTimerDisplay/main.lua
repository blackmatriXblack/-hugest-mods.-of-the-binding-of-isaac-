-- =============================================================================
--  SpeedrunTimerDisplay - The Binding of Isaac: Repentance
--  Shows a real-time speedrun timer on screen during runs
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SpeedrunTimerDisplay", 1)
local game = Game()

-- Track whether timer is running and start time
local timerRunning = false
local startTime = 0
local elapsedTime = 0

function mod:onGameStart()
    timerRunning = true
    startTime = Isaac.GetTime()
    elapsedTime = 0
end

function mod:onPostRender()
    if not timerRunning then return end
    if not game:GetHUD():IsVisible() then return end

    -- Update elapsed time
    local currentTime = Isaac.GetTime()
    elapsedTime = (currentTime - startTime) / 1000

    -- Format as HH:MM:SS.mmm
    local hours = math.floor(elapsedTime / 3600)
    local minutes = math.floor((elapsedTime % 3600) / 60)
    local seconds = math.floor(elapsedTime % 60)
    local millis = math.floor((elapsedTime % 1) * 100)
    local timeStr = string.format("SPEEDRUN: %02d:%02d:%02d.%02d", hours, minutes, seconds, millis)

    -- Draw at top-right corner
    local x = 420
    local y = 8
    Isaac.RenderText(timeStr, x, y, 1, 1, 1, 1)

    -- Draw best time if stored
    if mod.SaveData and mod.SaveData.bestTime then
        local best = mod.SaveData.bestTime
        local bh = math.floor(best / 3600)
        local bm = math.floor((best % 3600) / 60)
        local bs = math.floor(best % 60)
        local bms = math.floor((best % 1) * 100)
        local bestStr = string.format("BEST: %02d:%02d:%02d.%02d", bh, bm, bs, bms)
        Isaac.RenderText(bestStr, x, y + 14, 0.5, 0.8, 0.5, 1)
    end
end

function mod:onGameEnd()
    timerRunning = false
    -- Save best time
    if elapsedTime > 0 then
        if not mod.SaveData then mod.SaveData = {} end
        if not mod.SaveData.bestTime or elapsedTime < mod.SaveData.bestTime then
            mod.SaveData.bestTime = elapsedTime
        end
    end
    elapsedTime = 0
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)
mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.onGameEnd)

Isaac.DebugString("SpeedrunTimerDisplay loaded!")
