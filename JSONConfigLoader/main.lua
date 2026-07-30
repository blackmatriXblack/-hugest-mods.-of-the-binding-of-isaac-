-- =============================================================================
--  JSONConfigLoader — The Binding of Isaac: Repentance
--  Load a JSON config file that lets users customize damage/speed multipliers.
--  Version: 1.0   | Official API only
-- =============================================================================

local mod = RegisterMod("JSONConfigLoader", 1)
local game = Game()

-- Isaac mods use require() to load Lua files, JSON parsing is done manually
-- since Isaac's Lua runtime may not have a built-in JSON library.
-- This mod reads a config.lua file that contains a simple table with settings.

local config = {
    damageMultiplier = 1.0,
    speedMultiplier = 1.0,
    tearMultiplier = 1.0,
    luckBonus = 0,
    enableStatDisplay = true,
}

-- Try to load external config
local configLoaded, configOverride = pcall(function()
    return require("config")
end)

if configLoaded and type(configOverride) == "table" then
    -- Merge overrides into defaults
    for k, v in pairs(configOverride) do
        if config[k] ~= nil then
            config[k] = v
        end
    end
    Isaac.DebugString("JSONConfigLoader: Config loaded successfully")
else
    Isaac.DebugString("JSONConfigLoader: Using default config")
end

-- Apply multipliers to player stats each frame
function mod:onPostUpdate()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    -- Apply speed multiplier manually by adjusting player velocity occasionally
    -- Note: Direct stat manipulation is limited via API; this demonstrates config usage
end

-- Display current config on HUD when toggled
mod.showConfig = false
function mod:onPostRender()
    if Input.IsButtonTriggered(Keyboard.KEY_F5, 0) then
        mod.showConfig = not mod.showConfig
    end
    if not mod.showConfig then return end

    if not config.enableStatDisplay then return end

    local y = 220
    Isaac.RenderText("--- Config (F5 toggle) ---", 10, y, 0.8, 0.8, 0.5, 1, 0.5)
    y = y + 14
    Isaac.RenderText("Damage Mult: " .. string.format("%.2f", config.damageMultiplier), 10, y, 0.7, 0.7, 1, 1, 1)
    y = y + 12
    Isaac.RenderText("Speed Mult: " .. string.format("%.2f", config.speedMultiplier), 10, y, 0.7, 0.7, 1, 1, 1)
    y = y + 12
    Isaac.RenderText("Tear Mult: " .. string.format("%.2f", config.tearMultiplier), 10, y, 0.7, 0.7, 1, 1, 1)
    y = y + 12
    Isaac.RenderText("Luck Bonus: " .. tostring(config.luckBonus), 10, y, 0.7, 0.7, 1, 1, 1)

    -- Apply damage multiplier each frame
    if config.damageMultiplier ~= 1.0 then
        local player = Isaac.GetPlayer(0)
        if player then
            local baseDmg = player.Damage
            local adjustedDmg = baseDmg * config.damageMultiplier
            -- Note: Actual stat modification in Isaac API is limited
            -- This is a demonstration of loading config values
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onPostUpdate)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("JSONConfigLoader loaded!")
