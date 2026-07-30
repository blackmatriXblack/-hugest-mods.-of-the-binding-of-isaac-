-- =============================================================================
--  BossPreview - The Binding of Isaac: Repentance
--  Display boss room hint based on floor type before entering boss room
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BossPreview", 1)

local bossPool = {}
local showPreview = false
local currentStage = 1
local currentStageType = 0

-- Boss name database by stage
local BOSS_NAMES = {
    Basement = {"Monstro", "Gemini", "Larry Jr.", "Dingle", "Gurdy Jr.", "Little Horn", "Pin"},
    Cellar = {"Monstro", "Gemini", "Larry Jr.", "Dingle", "Gurdy Jr.", "Little Horn", "Pin", "The Haunt"},
    Caves = {"Mega Maw", "Gurdy", "Chub", "Mega Fatty", "The Gate", "Pestilence", "Famine"},
    Catacombs = {"Mega Maw", "Gurdy", "Chub", "Mega Fatty", "The Gate", "Pestilence", "Famine", "Dark One"},
    Depths = {"Monstro II", "Gish", "Loki", "The Adversary", "The Cage", "War", "Death"},
    Necropolis = {"Monstro II", "Gish", "Loki", "The Adversary", "The Cage", "War", "Death", "Mask of Infamy"},
    Womb = {"Scolex", "Teratoma", "Blastocyst", "Mama Gurdy", "Mr. Fred", "Conquest"},
    Utero = {"Scolex", "Teratoma", "Blastocyst", "Mama Gurdy", "Mr. Fred", "Conquest"},
    Sheol = {"Satan"},
    Cathedral = {"Isaac"},
    ["Chest"] = {"???"},
    ["Dark Room"] = {"The Lamb"},
    ["The Void"] = {"Delirium"},
    Home = {"Dogma", "The Beast"},
}

function mod:onNewLevel()
    local level = Game():GetLevel()
    if not level then return end

    currentStage = level:GetStage()
    currentStageType = level:GetStageType()

    -- Get stage name
    local stageNames = {
        [LevelStage.STAGE1_1] = "Basement", [LevelStage.STAGE1_2] = "Basement",
        [LevelStage.STAGE2_1] = "Caves", [LevelStage.STAGE2_2] = "Caves",
        [LevelStage.STAGE3_1] = "Depths", [LevelStage.STAGE3_2] = "Depths",
        [LevelStage.STAGE4_1] = "Womb", [LevelStage.STAGE4_2] = "Womb",
        [LevelStage.STAGE5] = "Sheol",
        [LevelStage.STAGE6] = "Cathedral",
        [LevelStage.STAGE7] = "Chest",
        [LevelStage.STAGE8] = "Dark Room",
        [LevelStage.STAGE9] = "The Void",
        [LevelStage.STAGE1_1_GREED] = "Basement",
        [LevelStage.STAGE2_1_GREED] = "Caves",
        [LevelStage.STAGE3_1_GREED] = "Depths",
        [LevelStage.STAGE1_1_WOTL] = "Basement",
    }

    local altStages = {
        Basement = "Cellar",
        Caves = "Catacombs",
        Depths = "Necropolis",
        Womb = "Utero",
    }

    local baseStage = stageNames[currentStage] or "???"
    local stageName = baseStage
    if currentStageType == 1 and altStages[baseStage] then
        stageName = altStages[baseStage]
    end

    bossPool = BOSS_NAMES[stageName] or {"???"}
    showPreview = true
end

function mod:onRender()
    if not showPreview then return end

    local room = Game():GetRoom()
    if not room then return end

    -- Only show if we're adjacent to boss room
    local roomDesc = room:GetCurrentRoomDesc()
    local shouldShow = false
    for i = 0, 3 do -- check all 4 directions
        local door = room:GetDoor(i)
        if door and door.TargetRoomIndex >= 0 then
            local targetRoom = room:GetRoomByIdx(door.TargetRoomIndex)
            if targetRoom and targetRoom.Data and targetRoom.Data.Type == RoomType.ROOM_BOSS then
                shouldShow = true
                break
            end
        end
    end

    if not shouldShow then return end

    local sw = Isaac.GetScreenWidth()
    local sh = Isaac.GetScreenHeight()
    local x = sw * 0.02
    local y = sh * 0.92

    -- Boss preview at bottom-left
    local bossList = ""
    for i, boss in ipairs(bossPool) do
        if i > 1 then bossList = bossList .. " / " end
        bossList = bossList .. boss
    end

    Isaac.RenderScaledText("BOSS ROOM:", x, y, 0.85, 0.85, 1, 0.3, 0.3, 1)
    Isaac.RenderScaledText(bossList, x, y + 16, 0.75, 0.75, 1, 0.8, 0.2, 1)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("BossPreview loaded!")
