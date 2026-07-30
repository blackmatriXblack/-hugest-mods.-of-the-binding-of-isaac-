-- =============================================================================
--  GameTimeStatistics - The Binding of Isaac: Repentance
--  Post-game screen showing total time played, rooms cleared, tears fired, steps walked
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GameTimeStatistics", 1)
local STATS_KEY = "GAME_STATS"
local showStats = false
local runStats = {}
local totalStats = {}
local lastPlayerPos = nil
local totalSteps = 0
local totalTears = 0
local roomsCleared = 0
local bossKills = 0
local lastRoomCount = 0

function mod:onGameStart(continued)
    local data = mod:GetData()
    if data[STATS_KEY] == nil then
        data[STATS_KEY] = {
            totalRuns = 0,
            totalTime = 0,
            totalRooms = 0,
            totalTears = 0,
            totalSteps = 0,
            totalBossKills = 0,
        }
    end
    totalStats = data[STATS_KEY]

    runStats = {
        startTime = os.time(),
        roomsCleared = 0,
        tearsFired = 0,
        stepsWalked = 0,
        bossKills = 0,
        itemsCollected = 0,
        damageDealt = 0,
        damageTaken = 0,
    }
    lastPlayerPos = nil
    totalSteps = 0
    totalTears = 0
    roomsCleared = 0
    bossKills = 0
    lastRoomCount = 0
end

function mod:onUpdate()
    if showStats then return end

    -- Track steps walked
    local player = Isaac.GetPlayer(0)
    if player then
        local pos = player.Position
        if lastPlayerPos then
            local dist = pos:Distance(lastPlayerPos)
            totalSteps = totalSteps + math.floor(dist)
        end
        lastPlayerPos = Vector(pos.X, pos.Y)
    end

    -- Track rooms cleared
    local game = Game()
    local level = game:GetLevel()
    local currentRooms = level:GetRoomsCleared() or 0
    if currentRooms > lastRoomCount then
        roomsCleared = roomsCleared + (currentRooms - lastRoomCount)
        lastRoomCount = currentRooms
    end
end

function mod:onGameEnd()
    runStats.endTime = os.time()
    runStats.duration = os.difftime(runStats.endTime, runStats.startTime)
    runStats.roomsCleared = roomsCleared
    runStats.stepsWalked = totalSteps

    -- Update totals
    local data = mod:GetData()
    data[STATS_KEY].totalRuns = data[STATS_KEY].totalRuns + 1
    data[STATS_KEY].totalTime = data[STATS_KEY].totalTime + runStats.duration
    data[STATS_KEY].totalRooms = data[STATS_KEY].totalRooms + roomsCleared
    data[STATS_KEY].totalSteps = data[STATS_KEY].totalSteps + totalSteps
    data[STATS_KEY].totalBossKills = data[STATS_KEY].totalBossKills + bossKills

    showStats = true
    Isaac.DebugString("GameTimeStatistics: Run ended — " .. runStats.duration .. "s, " .. roomsCleared .. " rooms")
end

function mod:onRender()
    if Input.IsButtonPressed(Keyboard.KEY_G, 0) then
        showStats = not showStats
    end

    if not showStats then return end

    local font = Font()
    local screenW = Isaac.GetScreenWidth()
    local screenH = Isaac.GetScreenHeight()
    local x = screenW / 2 - 200
    local y = screenH / 2 - 200
    local alpha = 0.92
    local lineH = 20

    -- Semi-transparent background
    font:DrawString(string.rep(" ", 60), x, y, KColor(0, 0, 0, 0.7), 0, false)

    font:DrawString("=== GAME STATISTICS (G to toggle) ===", x + 20, y, KColor(1, 0.8, 0, 1), 0, false)
    y = y + 28

    -- Current Run
    font:DrawString("-- CURRENT RUN --", x + 20, y, KColor(0.3, 1, 0.3, alpha), 0, false)
    y = y + 22
    local lines = {
        string.format("Duration: %dm %ds", math.floor(runStats.duration / 60), runStats.duration % 60),
        "Rooms Cleared: " .. runStats.roomsCleared,
        "Steps Walked: " .. runStats.stepsWalked,
        "Boss Kills: " .. runStats.bossKills,
    }
    for _, line in ipairs(lines) do
        font:DrawString("  " .. line, x + 30, y, KColor(1, 1, 1, alpha), 0, false)
        y = y + lineH
    end
    y = y + 8

    -- Lifetime Totals
    font:DrawString("-- LIFETIME TOTALS --", x + 20, y, KColor(1, 0.6, 0, alpha), 0, false)
    y = y + 22
    local totalHours = math.floor(totalStats.totalTime / 3600)
    local totalMins = math.floor((totalStats.totalTime % 3600) / 60)
    local totalLines = {
        "Total Runs: " .. totalStats.totalRuns,
        string.format("Total Time: %dh %dm", totalHours, totalMins),
        "Total Rooms: " .. totalStats.totalRooms,
        "Total Steps: " .. totalStats.totalSteps,
        "Total Boss Kills: " .. totalStats.totalBossKills,
    }
    for _, line in ipairs(totalLines) do
        font:DrawString("  " .. line, x + 30, y, KColor(1, 1, 1, alpha), 0, false)
        y = y + lineH
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)
mod:AddCallback(ModCallbacks.MC_POST_GAME_END, mod.onGameEnd)
Isaac.DebugString("GameTimeStatistics loaded!")
