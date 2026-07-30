-- =============================================================================
--  FloorPresetSelector - The Binding of Isaac: Repentance
--  Choose floor theme presets at start — all Basement? all Cathedral? random?
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FloorPresetSelector", 1)
local PRESET_KEY = "FLOOR_PRESET"
local selectedPreset = 0 -- 0=none, 1=Basement, 2=Caves, 3=Depths, 4=Cathedral, 5=Sheol, 6=Random
local presetNames = {
    "None (Default)",
    "All Basement (Training)",
    "All Caves",
    "All Depths",
    "All Cathedral",
    "All Sheol",
    "Full Random",
}

local stageMap = {
    Basement = {1, 2},
    Caves = {4, 5},
    Depths = {7, 8},
    Cathedral = {10, 11},
    Sheol = {12, 13},
}

function mod:onGameStart(continued)
    if continued then return end

    local data = mod:GetData()
    if data[PRESET_KEY] == nil then data[PRESET_KEY] = 0 end
    selectedPreset = data[PRESET_KEY]
    Isaac.DebugString("FloorPresetSelector: Preset = " .. presetNames[selectedPreset + 1])

    if selectedPreset == 0 then return end

    local level = Game():GetLevel()

    if selectedPreset <= 5 then
        -- Specific floor theme
        local themeNames = {"Basement", "Caves", "Depths", "Cathedral", "Sheol"}
        local theme = themeNames[selectedPreset]
        local stages = {
            Basement = 1, Caves = 4, Depths = 7, Cathedral = 10, Sheol = 12,
        }
        level:SetStage(stages[theme], 0)
        Isaac.DebugString("FloorPresetSelector: Overriding to " .. theme)
    elseif selectedPreset == 6 then
        -- Random theme
        local themes = {"Basement", "Caves", "Depths", "Cathedral", "Sheol"}
        local pick = themes[math.random(1, 5)]
        local stages = {
            Basement = 1, Caves = 4, Depths = 7, Cathedral = 10, Sheol = 12,
        }
        level:SetStage(stages[pick], 0)
        Isaac.DebugString("FloorPresetSelector: Random theme -> " .. pick)
    end
end

function mod:onRender()
    if Input.IsButtonPressed(Keyboard.KEY_F7, 0) then
        selectedPreset = selectedPreset + 1
        if selectedPreset > 6 then selectedPreset = 0 end
        mod:GetData()[PRESET_KEY] = selectedPreset
        Isaac.DebugString("FloorPresetSelector: Preset set to " .. presetNames[selectedPreset + 1])
    end

    -- Show current preset
    local font = Font()
    font:DrawString("Floor Preset [F7]: " .. presetNames[selectedPreset + 1],
        Isaac.GetScreenWidth() * 0.35, 5, KColor(0.3, 1, 1, 0.8), 0, false)
end

mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("FloorPresetSelector loaded!")
