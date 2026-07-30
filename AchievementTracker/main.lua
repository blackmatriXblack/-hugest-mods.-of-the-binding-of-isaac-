-- =============================================================================
--  AchievementTracker — The Binding of Isaac: Repentance
--  Display recent achievement progress on HUD.
--  Version: 1.0   | Official API only
-- =============================================================================

local mod = RegisterMod("AchievementTracker", 1)
local game = Game()
local achievementManager = Isaac.GetItemConfig():GetAchievements()

function mod:onPostRender()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    -- Check a range of achievement IDs for completion
    local unlocked = 0
    local total = 0
    local recentUnlocks = {}

    for id = 1, 50 do
        if achievementManager:IsValid(id) then
            if Isaac.GetPersistentGameData():IsAchievementUnlocked(id) then
                unlocked = unlocked + 1
                table.insert(recentUnlocks, id)
            end
        end
    end

    local text = "Achievements: " .. unlocked .. " unlocked (of first 50)"
    Isaac.RenderText(text, 10, 64, 0.8, 0.8, 1, 0.8, 0.2)

    -- Show last 5 unlocked achievement names
    local startIdx = math.max(1, #recentUnlocks - 4)
    for ii = startIdx, #recentUnlocks do
        local ach = achievementManager:GetAchievement(recentUnlocks[ii])
        if ach then
            local line = "  #" .. recentUnlocks[ii] .. ": " .. ach.Name
            local y = 64 + (ii - startIdx + 1) * 12
            Isaac.RenderText(line, 10, y, 0.6, 0.6, 0.3, 1, 0.3)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("AchievementTracker loaded!")
