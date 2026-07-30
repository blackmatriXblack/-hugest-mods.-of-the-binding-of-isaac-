-- =============================================================================
--  TearColorMood - The Binding of Isaac: Repentance
--  Tear color changes based on player's HP: green=full, yellow=half, red=low.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TearColorMood", 1)

function mod:onFireTear(tear)
    local player = Isaac.GetPlayer(0)
    if not player then return end

    local heartCount = player:GetHearts()
    local soulCount = player:GetSoulHearts()
    local maxHearts = player:GetMaxHearts()
    local total = heartCount + soulCount
    local ratio = total / math.max(maxHearts, 1)

    local r, g, b
    if ratio >= 0.75 then
        -- Green - healthy and vibrant
        r, g, b = 0.2, 1.0, 0.3
    elseif ratio >= 0.4 then
        -- Yellow/Orange - caution
        r, g, b = 1.0, 0.8, 0.1
    elseif ratio >= 0.2 then
        -- Red - danger
        r, g, b = 1.0, 0.2, 0.1
    else
        -- Dark red pulsing - critical
        r, g, b = 0.8, 0.05, 0.05
    end

    tear.Color = Color(r, g, b, 1.0, r * 0.5, g * 0.5, b * 0.5)
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.onFireTear)
Isaac.DebugString("TearColorMood loaded!")
