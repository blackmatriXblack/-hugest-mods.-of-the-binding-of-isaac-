-- =============================================================================
--  FloorTimer - The Binding of Isaac: Repentance
--  Display how long you have been on the current floor
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FloorTimer", 1)
local game = Game()
local floorStartFrame = 0

function mod:onNewLevel()
    floorStartFrame = game:GetFrameCount()
end

function mod:onRender()
    if floorStartFrame == 0 then
        floorStartFrame = game:GetFrameCount()
    end

    local elapsed = game:GetFrameCount() - floorStartFrame
    local seconds = elapsed / 30.0
    local minutes = math.floor(seconds / 60)
    local secs = math.floor(seconds % 60)

    local sw = Isaac.GetScreenWidth()
    local sh = Isaac.GetScreenHeight()
    local x = sw * 0.018
    local y = sh * 0.082

    -- Floor Timer display at top-left
    Isaac.RenderScaledText("Floor Time", x, y, 0.8, 0.8, 0.6, 0.8, 1, 1)
    Isaac.RenderScaledText(
        string.format("%02d:%02d", minutes, secs),
        x, y + 15, 1.2, 1.2, 1, 1, 1, 1
    )

    -- Visual clock bar (60s max per display segment, wraps)
    local secFraction = secs / 60.0
    local barLen = 16
    local filled = math.floor(secFraction * barLen)
    local barStr = string.rep("█", filled) .. string.rep("░", barLen - filled)
    local barColorR, barColorG = 0.4, 0.9
    if seconds > 120 then barColorR, barColorG = 0.9, 0.4 end
    Isaac.RenderScaledText(barStr, x, y + 34, 0.6, 0.6, barColorR, barColorG, 1, 0.85)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("FloorTimer loaded!")
