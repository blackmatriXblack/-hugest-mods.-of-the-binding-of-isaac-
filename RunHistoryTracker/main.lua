-- =============================================================================
--  RunHistoryTracker - The Binding of Isaac: Repentance
--  Save and view run history — track character, floor, death cause, items
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RunHistoryTracker", 1)
local HISTORY_KEY = "RUN_HISTORY"
local showHistory = false
local historyData = {}
local currentRun = {}

local function InitCurrentRun()
    currentRun = {
        character = "",
        startTime = 0,
        floors = 0,
        items = {},
        deathCause = "Unknown",
        roomsCleared = 0,
        hasEnded = false,
    }
end

function mod:onGameStart(continued)
    local data = mod:GetData()
    if data[HISTORY_KEY] == nil then
        data[HISTORY_KEY] = {}
    end
    historyData = data[HISTORY_KEY]
    InitCurrentRun()

    if not continued then
        local player = Isaac.GetPlayer(0)
        local playerType = player:GetPlayerType()
        local names = {
            [0] = "Isaac", [1] = "Magdalene", [2] = "Cain", [3] = "Judas",
            [4] = "Blue Baby", [5] = "Eve", [6] = "Samson", [7] = "Azazel",
            [8] = "Lazarus", [9] = "Eden", [10] = "The Lost", [11] = "Lazarus II",
            [12] = "Dark Judas", [13] = "Lilith", [14] = "Keeper",
            [15] = "Apollyon", [16] = "The Forgotten", [17] = "The Soul",
            [18] = "Bethany", [19] = "Jacob", [20] = "Esau",
            [21] = "Tainted Isaac", [22] = "Tainted Magdalene",
        }
        currentRun.character = names[playerType] or ("Char_" .. tostring(playerType))
        currentRun.startTime = os.time()
    end
    Isaac.DebugString("RunHistoryTracker: New run started!")
end

function mod:onGameEnd()
    if currentRun.hasEnded then return end
    currentRun.hasEnded = true

    local game = Game()
    local level = game:GetLevel()
    currentRun.floors = level:GetStage() + (level:GetStageType() - 1) * 1 or 0

    -- Determine cause of death or victory
    local player = Isaac.GetPlayer(0)
    if player:IsDead() then
        local lastDamage = player:GetLastDamageFlags()
        if (lastDamage & DamageFlag.DAMAGE_FIRE) ~= 0 then currentRun.deathCause = "Fire" end
        if (lastDamage & DamageFlag.DAMAGE_SPIKES) ~= 0 then currentRun.deathCause = "Spikes" end
        if (lastDamage & DamageFlag.DAMAGE_EXPLOSION) ~= 0 then currentRun.deathCause = "Explosion" end
    elseif level:GetStage() >= 12 then
        currentRun.deathCause = "Victory"
    end

    currentRun.roomsCleared = level:GetRoomsCleared() or 0

    -- Save to persistent data
    local data = mod:GetData()
    table.insert(data[HISTORY_KEY], {
        character = currentRun.character,
        floors = currentRun.floors,
        deathCause = currentRun.deathCause,
        items = #currentRun.items,
        roomsCleared = currentRun.roomsCleared,
        time = os.date("%Y-%m-%d %H:%M"),
        duration = os.difftime(os.time(), currentRun.startTime),
    })

    -- Keep only last 50 runs
    while #data[HISTORY_KEY] > 50 do
        table.remove(data[HISTORY_KEY], 1)
    end
    historyData = data[HISTORY_KEY]
    Isaac.DebugString("RunHistoryTracker: Run saved! Total runs: " .. #data[HISTORY_KEY])
end

function mod:onRender()
    -- Toggle with H key
    if Input.IsButtonPressed(Keyboard.KEY_H, 0) then
        showHistory = not showHistory
    end

    if not showHistory then return end

    local font = Font()
    local y = 40
    local x = 60
    local alpha = 0.85

    font:DrawString("=== RUN HISTORY (H to toggle) ===", x, y, KColor(1, 1, 1, alpha), 0, false)
    y = y + 20

    local start = math.max(1, #historyData - 15)
    for i = start, #historyData do
        local r = historyData[i]
        local line = string.format("#%d %s | %s | Floor %d | %s | %d items | %ss",
            i, r.time, r.character, r.floors, r.deathCause, r.items, math.floor(r.duration or 0))
        font:DrawString(line, x, y, KColor(1, 1, 0.5, alpha), 0, false)
        y = y + 16
    end

    font:DrawString("Total runs: " .. #historyData, x, y + 10, KColor(0.5, 1, 0.5, alpha), 0, false)
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)
mod:AddCallback(ModCallbacks.MC_POST_GAME_END, mod.onGameEnd)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("RunHistoryTracker loaded!")
