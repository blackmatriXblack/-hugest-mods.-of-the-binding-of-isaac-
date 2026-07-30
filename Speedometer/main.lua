-- =============================================================================
--  Speedometer - The Binding of Isaac: Repentance
--  Display current player movement speed as a number and gauge
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("Speedometer", 1)

local speedHistory = {}
local MAX_HISTORY = 60

function mod:onRender()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    local vel = player.Velocity
    local currentSpeed = math.sqrt(vel.X * vel.X + vel.Y * vel.Y)
    local baseSpeed = player.MoveSpeed

    -- Track speed history for average
    speedHistory[#speedHistory + 1] = currentSpeed
    if #speedHistory > MAX_HISTORY then
        table.remove(speedHistory, 1)
    end

    local totalSpeed = 0
    for _, s in ipairs(speedHistory) do
        totalSpeed = totalSpeed + s
    end
    local avgSpeed = #speedHistory > 0 and totalSpeed / #speedHistory or 0

    local sw = Isaac.GetScreenWidth()
    local sh = Isaac.GetScreenHeight()
    local x = sw * 0.018
    local y = sh * 0.62

    -- Title
    Isaac.RenderScaledText("Speedometer", x, y, 0.85, 0.85, 0.3, 1, 0.8, 1)

    -- Current speed display
    Isaac.RenderScaledText(
        string.format("Spd: %.2f", currentSpeed),
        x, y + 16, 1.2, 1.2, 0.3, 1, 0.6, 1
    )

    -- Base speed
    Isaac.RenderScaledText(
        string.format("Base: %.2f", baseSpeed),
        x, y + 34, 0.7, 0.7, 0.6, 0.6, 0.6, 0.8
    )

    -- Average speed
    Isaac.RenderScaledText(
        string.format("Avg: %.2f", avgSpeed),
        x, y + 48, 0.7, 0.7, 0.5, 0.7, 1, 0.8
    )

    -- Speed gauge bar (max speed ~2.5 for reference)
    local maxDisplay = 3.0
    local ratio = math.min(currentSpeed / maxDisplay, 1.0)
    local barLen = 22
    local filled = math.floor(ratio * barLen)
    local barStr = string.rep("█", filled) .. string.rep("░", barLen - filled)

    local barR, barG = 0.3, 1
    if currentSpeed > 2.0 then barR, barG = 1, 0.3 end
    Isaac.RenderScaledText(barStr, x, y + 64, 0.55, 0.55, barR, barG, 0.4, 0.85)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("Speedometer loaded!")
