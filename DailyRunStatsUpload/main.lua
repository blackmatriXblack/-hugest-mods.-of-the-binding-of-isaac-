-- =============================================================================
--  DailyRunStatsUpload - The Binding of Isaac: Repentance
--  Save daily run results locally — score, time, floor, items
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DailyRunStatsUpload", 1)
local STATS_KEY = "DAILY_RUN_STATS"
local DAILY_DATA_KEY = "DAILY_HISTORY"
local dailyResults = {}
local showStats = false
local currentRunStarted = false
local currentRunData = {}

function mod:onGameStart(continued)
    currentRunStarted = true
    currentRunData = {
        date = os.date("%Y-%m-%d"),
        score = 0,
        time = 0,
        floor = 0,
        items = 0,
        enemiesKilled = 0,
        bossRush = false,
        hush = false,
        isDaily = false,
    }

    local game = Game()
    currentRunData.isDaily = game:IsDailyRun()
    if not currentRunData.isDaily then return end

    Isaac.DebugString("DailyRunStatsUpload: Daily run started!")
end

function mod:onGameEnd()
    if not currentRunStarted then return end

    local game = Game()
    local level = game:GetLevel()
    local player = Isaac.GetPlayer(0)

    currentRunData.score = game:GetScore()
    currentRunData.floor = level:GetStage() or 0
    currentRunData.time = os.time()
    currentRunData.enemiesKilled = level:GetEnemiesKilled() or 0

    -- Save to persistent data
    local data = mod:GetData()
    if data[DAILY_DATA_KEY] == nil then data[DAILY_DATA_KEY] = {} end

    table.insert(data[DAILY_DATA_KEY], currentRunData)

    -- Keep last 30 daily runs
    while #data[DAILY_DATA_KEY] > 30 do
        table.remove(data[DAILY_DATA_KEY], 1)
    end

    dailyResults = data[DAILY_DATA_KEY]
    currentRunStarted = false

    Isaac.DebugString(string.format("DailyRunStatsUpload: Saved — Score: %d, Floor: %d",
        currentRunData.score, currentRunData.floor))
end

function mod:onRender()
    if Input.IsButtonPressed(Keyboard.KEY_D, 0) then
        showStats = not showStats
        if showStats then
            local data = mod:GetData()
            if data[DAILY_DATA_KEY] == nil then data[DAILY_DATA_KEY] = {} end
            dailyResults = data[DAILY_DATA_KEY]
        end
    end

    if not showStats then return end

    local font = Font()
    local screenW = Isaac.GetScreenWidth()
    local x = screenW / 2 - 200
    local y = 80
    local alpha = 0.85

    font:DrawString("=== DAILY RUN HISTORY (D to toggle) ===", x, y, KColor(1, 0.8, 0, alpha), 0, false)
    y = y + 24

    -- Find best score
    local bestScore = 0
    local bestIndex = 0
    for i, r in ipairs(dailyResults) do
        if r.score > bestScore then
            bestScore = r.score
            bestIndex = i
        end
    end

    font:DrawString(string.format("Best Score: %d   |   Total Daily Runs: %d",
        bestScore, #dailyResults), x, y, KColor(0.3, 1, 0.3, alpha), 0, false)
    y = y + 28

    local start = math.max(1, #dailyResults - 12)
    for i = start, #dailyResults do
        local r = dailyResults[i]
        local marker = (i == bestIndex) and " [BEST]" or ""
        font:DrawString(string.format("#%d %s | Score: %d | Floor: %d%s",
            i, r.date, r.score, r.floor, marker), x + 10, y, KColor(1, 1, 0.7, alpha), 0, false)
        y = y + 16
    end
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)
mod:AddCallback(ModCallbacks.MC_POST_GAME_END, mod.onGameEnd)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("DailyRunStatsUpload loaded!")
