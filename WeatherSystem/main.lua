-- ==========================================================================
--  WeatherSystem - The Binding of Isaac: Repentance
--  Rooms have random weather: rain particles, snow, or falling leaves!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("WeatherSystem", 1)
local weatherType = 0
local weatherIntensity = 0
local WEATHER_TYPES = {"rain", "snow", "leaves", "ash", "sparks"}

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    weatherType = math.random(0, #WEATHER_TYPES)
    weatherIntensity = math.random(3, 8)
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local room = Game():GetRoom()
    local tl = room:GetTopLeftPos()
    local br = room:GetBottomRightPos()
    local w = br.X - tl.X
    local h = br.Y - tl.Y

    for i = 1, weatherIntensity * 2 do
        local rx = tl.X + math.random() * w
        local ry = tl.Y + math.random() * h * 2 - h

        local velX = 0
        local velY = 1 + math.random() * 2
        local effectVariant = EffectVariant.POOF01

        if weatherType == 1 then
            effectVariant = EffectVariant.SPARKLE
            velY = 0.5 + math.random()
            velX = math.random() * 2 - 1
        elseif weatherType == 2 then
            effectVariant = EffectVariant.DARK_BALL_SMOKE_PARTICLE
            velY = 0.8 + math.random() * 1.5
            velX = math.sin(Game():GetFrameCount() * 0.05 + i) * 2
        elseif weatherType == 3 then
            effectVariant = EffectVariant.SMOKE_CLOUD
            velY = 0.4 + math.random() * 0.5
            velX = math.random() * 0.5 - 0.25
        elseif weatherType == 4 then
            effectVariant = EffectVariant.FIRE_TRAIL
            velY = 2 + math.random() * 3
        end

        local particle = Isaac.Spawn(EntityType.ENTITY_EFFECT, effectVariant, 0,
            Vector(rx, ry + math.random() * 20 - 20), Vector(velX, velY), nil)
        if particle then
            particle:SetTimeout(8 + math.random(0, 10))
            if weatherType == 1 then
                particle:SetColor(Color(0.9, 0.95, 1, 0.6, 0, 0, 0), 0, 0)
            elseif weatherType == 2 then
                local c = math.random()
                if c < 0.33 then
                    particle:SetColor(Color(0.8, 0.3, 0.1, 0.7, 0, 0, 0), 0, 0)
                elseif c < 0.66 then
                    particle:SetColor(Color(1, 0.7, 0.1, 0.7, 0, 0, 0), 0, 0)
                else
                    particle:SetColor(Color(0.7, 0.2, 0, 0.7, 0, 0, 0), 0, 0)
                end
            end
        end
    end
end)

Isaac.DebugString("WeatherSystem loaded! " .. WEATHER_TYPES[math.random(#WEATHER_TYPES)] .. " incoming!")
