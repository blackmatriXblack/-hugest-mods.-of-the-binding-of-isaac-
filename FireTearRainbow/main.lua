-- =============================================================================
--  FireTearRainbow — The Binding of Isaac: Repentance
--  Each tear gets a random Color tint, changing every shot.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FireTearRainbow", 1)
local colorIndex = 0
local rainbowColors = {
    Color(1, 0, 0, 1, 0, 0, 0),     -- Red
    Color(1, 0.5, 0, 1, 0, 0, 0),   -- Orange
    Color(1, 1, 0, 1, 0, 0, 0),     -- Yellow
    Color(0, 1, 0, 1, 0, 0, 0),     -- Green
    Color(0, 0.5, 1, 1, 0, 0, 0),   -- Blue
    Color(0.3, 0, 1, 1, 0, 0, 0),   -- Indigo
    Color(1, 0, 1, 1, 0, 0, 0),     -- Magenta
    Color(0, 1, 1, 1, 0, 0, 0),     -- Cyan
    Color(1, 0.7, 0.8, 1, 0, 0, 0), -- Pink
    Color(0.5, 0, 1, 1, 0, 0, 0),   -- Purple
}

function mod:onFireTear(tear)
    if tear then
        colorIndex = (colorIndex % #rainbowColors) + 1
        tear:SetColor(rainbowColors[colorIndex], 999999, 0)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.onFireTear)
Isaac.DebugString("FireTearRainbow loaded!")
