-- ==========================================================================
--  Windy Rooms - The Binding of Isaac: Repentance
--  All rooms have wind pushing player and tears in random directions
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("WindyRooms", 1)
local game = Game()
local windDirection = Vector(0, 0)
local windTimer = 0
local WIND_CHANGE = 120 -- Change wind direction every 4 seconds

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    -- Set random initial wind direction
    local angle = math.random() * math.pi * 2
    windDirection = Vector(math.cos(angle), math.sin(angle)) * 1.5
    windTimer = 0
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    windTimer = windTimer + 1

    -- Change wind direction periodically
    if windTimer >= WIND_CHANGE then
        windTimer = 0
        local angle = math.random() * math.pi * 2
        local strength = 0.5 + math.random() * 2.5
        windDirection = Vector(math.cos(angle), math.sin(angle)) * strength
    end

    -- Apply wind force to player
    player.Velocity = player.Velocity + windDirection * 0.8

    -- Visual wind lines
    if windTimer % 10 == 0 then
        local pos = player.Position
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY,
            0, pos + windDirection * -20, windDirection, nil)
    end
end)

-- Wind also affects tears
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
    tear.Velocity = tear.Velocity + windDirection * 0.3
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local angle = math.atan2(windDirection.Y, windDirection.X) * 180 / math.pi
    local strength = windDirection:Length()
    
    local windSymbols = {"--->", ">>>", "->>->"}
    local symbol = windSymbols[math.min(3, math.floor(strength) + 1)]

    -- Show wind direction indicator
    if strength > 0.5 then
        Isaac.RenderText(string.format("Wind: %.0f deg (%.1f)",
            angle, strength),
            game:GetScreenTopLeft().X + 40, game:GetScreenTopLeft().Y + 40,
            0.5, 0.7, 0.7, 1)
    end
end)

Isaac.DebugString("Windy Rooms loaded!")
