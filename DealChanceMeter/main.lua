-- =============================================================================
--  DealChanceMeter - The Binding of Isaac: Repentance
--  Angel and Devil room chance as a visual progress bar
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DealChanceMeter", 1)

function mod:onRender()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    local level = Game():GetLevel()
    if not level then return end

    local devilChance = level:GetDevilRoomChance()
    local angelChance = level:GetAngelRoomChance()

    -- Stage name for display
    local stageNames = {
        [LevelStage.STAGE1_1] = "B1", [LevelStage.STAGE1_2] = "B2",
        [LevelStage.STAGE2_1] = "C1", [LevelStage.STAGE2_2] = "C2",
        [LevelStage.STAGE3_1] = "D1", [LevelStage.STAGE3_2] = "D2",
        [LevelStage.STAGE4_1] = "W1", [LevelStage.STAGE4_2] = "W2",
        [LevelStage.STAGE5] = "SHE", [LevelStage.STAGE6] = "CAT",
        [LevelStage.STAGE7] = "CHS", [LevelStage.STAGE8] = "DKR",
        [LevelStage.STAGE9] = "VOD",
    }

    local currentStage = level:GetStage()
    local stageName = stageNames[currentStage] or "???"

    local sw = Isaac.GetScreenWidth()
    local sh = Isaac.GetScreenHeight()
    local x = sw * 0.74
    local y = sh * 0.08

    -- Title
    Isaac.RenderScaledText("Deal Chance", x, y, 0.8, 0.8, 1, 0.5, 0.9, 1)

    -- Devil deal bar
    if devilChance > 0 then
        local ratio = math.min(devilChance / 100.0, 1.0)
        local barLen = 20
        local filled = math.floor(ratio * barLen)
        local barStr = string.rep("█", filled) .. string.rep("░", barLen - filled)

        Isaac.RenderScaledText(
            string.format("Devil: %.1f%%", devilChance),
            x, y + 16, 0.75, 0.75, 1, 0.2, 0.2, 1
        )
        Isaac.RenderScaledText(barStr, x, y + 30, 0.55, 0.55, 0.9, 0.15, 0.15, 0.85)
    else
        Isaac.RenderScaledText(
            "Devil: 0% (locked)", x, y + 16, 0.7, 0.7, 0.4, 0.4, 0.4, 0.8
        )
    end

    -- Angel deal bar
    local angelY = y + (devilChance > 0 and 46 or 32)
    if angelChance > 0 then
        local ratio = math.min(angelChance / 100.0, 1.0)
        local barLen = 20
        local filled = math.floor(ratio * barLen)
        local barStr = string.rep("█", filled) .. string.rep("░", barLen - filled)

        Isaac.RenderScaledText(
            string.format("Angel: %.1f%%", angelChance),
            x, angelY, 0.75, 0.75, 0.5, 0.7, 1, 1
        )
        Isaac.RenderScaledText(barStr, x, angelY + 14, 0.55, 0.55, 0.3, 0.5, 1, 0.85)
    end

    -- Deal type indicator
    local dealType = level:GetStateFlag(LevelStateFlag.STATE_DEVILROOM_SPAWNED) and "Devil Spawned"
        or level:GetStateFlag(LevelStateFlag.STATE_ANGELROOM_SPAWNED) and "Angel Spawned"
        or (devilChance + angelChance > 0 and "Pending" or "N/A")

    local dtR, dtG, dtB = 0.6, 0.6, 0.6
    if dealType == "Devil Spawned" then dtR, dtG, dtB = 1, 0.2, 0.2
    elseif dealType == "Angel Spawned" then dtR, dtG, dtB = 0.3, 0.6, 1
    end

    local labelY = angelChance > 0 and angelY + 30 or angelY + 16
    Isaac.RenderScaledText(dealType, x, labelY, 0.7, 0.7, dtR, dtG, dtB, 1)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("DealChanceMeter loaded!")
