-- =============================================================================
--  ChallengeProgressBar - The Binding of Isaac: Repentance
--  Show a progress bar toward challenge completion target on screen
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ChallengeProgressBar", 1)
local showBar = true

-- Challenge targets (boss/mom/heart/satan/isaac/???/lamb/mega satan/delirium/hush/mother/beast)
local challengeTargets = {
    [0] = nil, -- no challenge
    
    [0] = {name = "Dark Was The Night", target = 8},   -- Mom's Heart
}

-- Simplified stage-to-progress mapping
local stageProgress = {
    [1] = 1, [2] = 2, [3] = 2,  -- Basement
    [4] = 3, [5] = 4, [6] = 4,  -- Caves
    [7] = 5, [8] = 6, [9] = 6,  -- Depths
    [10] = 7, [11] = 8,          -- Womb
    [12] = 9, [13] = 10,         -- Sheol/Cathedral
    [14] = 10, [15] = 10,        -- Dark Room/Chest
    [16] = 11,                    -- Mega Satan
    [17] = 11,                    -- Void
    [18] = 12,                    -- Home
}

function mod:onRender()
    if Input.IsButtonPressed(Keyboard.KEY_P, 0) then
        showBar = not showBar
    end

    if not showBar then return end

    local game = Game()
    local challenge = game:GetChallenge()
    if challenge <= 0 then return end

    local level = game:GetLevel()
    local stage = level:GetStage()
    local stageType = level:GetStageType()
    local progress = math.min(stageProgress[stage] or 0, 12)
    local maxProgress = 12 -- Default target
    
    local challengeNames = {
        [1] = "Pitch Black", [2] = "High Brow", [3] = "Head Trauma",
        [4] = "Darkness Falls", [5] = "The Tank", [6] = "Solar System",
        [7] = "Suicide King", [8] = "Cat Got Your Tongue",
        [9] = "Demo Man", [10] = "Cursed!", [11] = "Glass Cannon",
        [12] = "When Life Gives You Lemons", [13] = "Beans!",
        [14] = "It's In The Cards", [15] = "Slow Roll",
        [16] = "Computer Savvy", [17] = "Waka Waka", [18] = "The Host",
        [19] = "The Family Man", [20] = "Purist", [21] = "XXXXXXXXL",
        [22] = "SPEED!", [23] = "Blue Bomber", [24] = "PAY TO PLAY",
        [25] = "Have a Heart", [26] = "I RULE!", [27] = "BRAINS!",
        [28] = "PRIDE DAY!", [29] = "Onan's Streak", [30] = "The Guardian",
        [31] = "Backasswards", [32] = "Aprils Fool", [33] = "Pokey Mans",
        [34] = "Ultra Hard", [35] = "Pong", [36] = "Scat Man",
        [37] = "Bloody Mary", [38] = "Baptism by Fire", [39] = "Isaac's Awakening",
        [40] = "Seeing Double", [41] = "Pica Run", [42] = "Hot Potato",
        [43] = "Cantripped!", [44] = "Red Redemption", [45] = "DELETE THIS",
    }

    local challengeName = challengeNames[challenge] or ("Challenge #" .. tostring(challenge))

    local screenW = Isaac.GetScreenWidth()
    local barWidth = 200
    local barHeight = 20
    local barX = (screenW - barWidth) / 2
    local barY = 10
    local ratio = math.min(progress / maxProgress, 1.0)

    local font = Font()

    -- Title
    font:DrawString(string.format("Challenge: %s (P to hide)", challengeName),
        (screenW - 300) / 2, barY - 18, KColor(1, 0.8, 0, 1), 0, false)

    -- Background bar
    font:DrawString(string.rep("_", math.floor(barWidth / 8)),
        barX, barY, KColor(0.3, 0.3, 0.3, 0.8), 0, false)

    -- Progress fill
    local fillChars = math.floor(ratio * barWidth / 8)
    local fillColor = KColor(0.2, 1, 0.2, 0.9)
    if ratio > 0.75 then fillColor = KColor(0.2, 1, 0.2, 1) end
    font:DrawString(string.rep("_", fillChars), barX, barY, fillColor, 0, false)

    -- Percentage
    font:DrawString(string.format("%d%%", math.floor(ratio * 100)),
        barX + barWidth / 2 - 15, barY + 24, KColor(1, 1, 1, 1), 0, false)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("ChallengeProgressBar loaded!")
