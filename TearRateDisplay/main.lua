-- =============================================================================
--  TearRateDisplay - The Binding of Isaac: Repentance
--  Show tear delay as a numeric value and fire rate bar on screen
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TearRateDisplay", 1)

function mod:onRender()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    local tearDelay = player.TearDelay
    local maxDelay = player.MaxFireDelay
    local tearsPerSec = 0
    if tearDelay > 0 then
        tearsPerSec = 30.0 / (tearDelay + 1)
    end

    local sw = Isaac.GetScreenWidth()
    local sh = Isaac.GetScreenHeight()
    local x = sw * 0.018
    local y = sh * 0.42

    -- Title
    Isaac.RenderScaledText("Tear Rate", x, y, 0.9, 0.9, 0.4, 0.7, 1, 1)

    -- Tear delay value
    Isaac.RenderScaledText(
        string.format("Delay: %d  (%.1f/s)", tearDelay, tearsPerSec),
        x, y + 16, 1.1, 1.1, 1, 1, 1, 1
    )

    -- Fire rate bar (lower delay = faster = more filled)
    local minDelay = 0
    local maxDisplayDelay = 60
    local ratio = 1.0 - math.min(math.max((tearDelay - minDelay) / maxDisplayDelay, 0), 1.0)
    local barLen = 24
    local filled = math.floor(ratio * barLen)

    -- Bar background
    Isaac.RenderScaledText("[                        ]", x, y + 34, 0.55, 0.55, 0.3, 0.3, 0.3, 0.5)
    -- Filled portion
    if filled > 0 then
        local fillStr = string.rep("I", filled)
        Isaac.RenderScaledText("[" .. fillStr, x, y + 34, 0.55, 0.55, 0.3, 0.8, 1, 1)
    end

    -- Rate category
    local category, catR, catG, catB = "Slow", 1, 0.3, 0.3
    if tearsPerSec >= 8 then category, catR, catG, catB = "Rapid", 0.3, 1, 0.3
    elseif tearsPerSec >= 5 then category, catR, catG, catB = "Fast", 0.3, 1, 1
    elseif tearsPerSec >= 3 then category, catR, catG, catB = "Normal", 1, 1, 0.3
    end
    Isaac.RenderScaledText(category, x, y + 50, 0.8, 0.8, catR, catG, catB, 1)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("TearRateDisplay loaded!")
