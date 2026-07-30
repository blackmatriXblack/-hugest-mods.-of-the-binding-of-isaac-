-- =============================================================================
--  ConsoleCommandAlias - The Binding of Isaac: Repentance
--  Custom keybindings — press keys to execute console commands
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ConsoleCommandAlias", 1)
local cooldowns = {}
local COMMAND_COOLDOWN = 30

-- Key bindings to console commands
local keyBindings = {
    {key = Keyboard.KEY_K, command = "restart", description = "K = Restart run"},
    {key = Keyboard.KEY_C, command = "clearseeds", description = "C = Clear seeds"},
    {key = Keyboard.KEY_M, command = "giveitem Brimstone", description = "M = Give Brimstone"},
    {key = Keyboard.KEY_R, command = "remove", description = "R = Remove HUD offset"},
    {key = Keyboard.KEY_J, command = "stage 13", description = "J = Jump to Cathedral"},
    {key = Keyboard.KEY_O, command = "costumetest", description = "O = Toggle costumetest"},
    {key = Keyboard.KEY_N, command = "giveitem Treasure Map", description = "N = Give Treasure Map"},
    {key = Keyboard.KEY_1, command = "debug 2", description = "1 = Damage debug"},
    {key = Keyboard.KEY_2, command = "debug 3", description = "2 = Infinite HP"},
    {key = Keyboard.KEY_3, command = "debug 4", description = "3 = Debug toggle"},
    {key = Keyboard.KEY_4, command = "debug 7", description = "4 = Stat display"},
    {key = Keyboard.KEY_5, command = "debug 8", description = "5 = Active item charge"},
    {key = Keyboard.KEY_6, command = "debug 9", description = "6 = Grid display"},
    {key = Keyboard.KEY_7, command = "debug 10", description = "7 = Quick kill"},
}

local function ExecuteCommand(cmd)
    Isaac.ExecuteCommand(cmd)
    Isaac.DebugString("ConsoleCommandAlias: Executed \"" .. cmd .. "\"")
end

function mod:onUpdate()
    -- Decrease cooldowns
    for key, val in pairs(cooldowns) do
        cooldowns[key] = val - 1
        if cooldowns[key] <= 0 then cooldowns[key] = nil end
    end

    -- Check each binding
    for _, binding in ipairs(keyBindings) do
        local keyName = tostring(binding.key)
        local cd = cooldowns[keyName] or 0
        if cd <= 0 and Input.IsButtonPressed(binding.key, 0) then
            ExecuteCommand(binding.command)
            cooldowns[keyName] = COMMAND_COOLDOWN
        end
    end
end

function mod:onRender()
    -- Show bindings help with F10
    if Input.IsButtonPressed(Keyboard.KEY_F10, 0) then
        return -- Will show in next frame if we persist state; simplified toggle
    end

    -- Always show a small hint
    local font = Font()
    font:DrawString("[F10] View Command Aliases",
        Isaac.GetScreenWidth() - 200, Isaac.GetScreenHeight() - 20,
        KColor(0.5, 0.8, 1, 0.6), 0, false)

    -- Show full bindings overlay when F10 is held (simplified: we check each frame)
    if Input.IsButtonPressed(Keyboard.KEY_F10, 0) then
        local x = 40
        local y = 40
        local lineH = 14
        font:DrawString("=== CONSOLE COMMAND ALIASES ===", x, y, KColor(0.3, 1, 1, 1), 0, false)
        y = y + 20
        for _, binding in ipairs(keyBindings) do
            font:DrawString("  " .. binding.description, x + 10, y, KColor(0.8, 1, 0.8, 0.9), 0, false)
            y = y + lineH
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("ConsoleCommandAlias loaded!")
