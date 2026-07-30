-- =============================================================================
--  AutoUnlockTracker - The Binding of Isaac: Repentance
--  Track which unlocks you've gotten this run in real-time sidebar
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("AutoUnlockTracker", 1)
local unlocksThisRun = {}
local showTracker = false
local lastUnlockCount = 0

function mod:onRender()
    -- Toggle with U key
    if Input.IsButtonPressed(Keyboard.KEY_U, 0) then
        showTracker = not showTracker
    end

    -- Check for new unlocks
    local allAchievements = {}
    for i = 1, 637 do
        allAchievements[i] = Isaac.GetAchievementById(i - 1)
    end

    local currentUnlocked = 0
    for i = 1, 637 do
        if allAchievements[i] then
            currentUnlocked = currentUnlocked + 1
        end
    end

    if currentUnlocked > lastUnlockCount then
        -- New unlocks detected — find which ones
        for i = 1, 637 do
            if allAchievements[i] then
                local already = false
                for _, uid in ipairs(unlocksThisRun) do
                    if uid == i then already = true; break end
                end
                if not already then
                    table.insert(unlocksThisRun, i)
                end
            end
        end
        lastUnlockCount = currentUnlocked
    end

    if not showTracker then return end

    local font = Font()
    local x = Isaac.GetScreenWidth() - 280
    local y = 60
    local alpha = 0.85

    font:DrawString("=== UNLOCKS THIS RUN (U to hide) ===", x, y, KColor(1, 0.8, 0, alpha), 0, false)
    y = y + 22

    if #unlocksThisRun == 0 then
        font:DrawString("  No unlocks yet...", x + 10, y, KColor(0.5, 0.5, 0.5, alpha), 0, false)
    else
        for i = 1, math.min(#unlocksThisRun, 20) do
            local achId = unlocksThisRun[i]
            local achName = Isaac.GetAchievementById(achId - 1) and "Achievement #" .. achId or "Unknown"
            font:DrawString(string.format("  + %s", achName), x + 10, y, KColor(0.3, 1, 0.3, alpha), 0, false)
            y = y + 16
        end
    end

    font:DrawString(string.format("Total: %d new unlocks", #unlocksThisRun),
        x, y + 16, KColor(1, 1, 0.5, alpha), 0, false)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("AutoUnlockTracker loaded!")
