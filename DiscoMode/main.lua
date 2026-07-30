-- ==========================================================================
--  DiscoMode - The Binding of Isaac: Repentance
--  Room lights cycle through rainbow colors with disco ball effect on bosses!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("DiscoMode", 1)
local hue = 0
local discoBallAngle = 0

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    hue = (hue + 1.5) % 360
    local c = Color(1, 1, 1, 1, 0, 0, 0)

    local r, g, b = 0, 0, 0
    local h = hue / 60
    local x = 1 - math.abs((h % 2) - 1)
    if h < 1 then r, g, b = 1, x, 0
    elseif h < 2 then r, g, b = x, 1, 0
    elseif h < 3 then r, g, b = 0, 1, x
    elseif h < 4 then r, g, b = 0, x, 1
    elseif h < 5 then r, g, b = x, 0, 1
    else r, g, b = 1, 0, x end

    c = Color(r * 0.3, g * 0.3, b * 0.3, 0.15, 0, 0, 0)

    local room = Game():GetRoom()
    local tl = room:GetTopLeftPos()
    local br = room:GetBottomRightPos()

    for _, ent in pairs(Isaac.GetRoomEntities()) do
        if ent:IsBoss() then
            discoBallAngle = discoBallAngle + 4
            local spr = ent:GetSprite()
            if spr then spr.Color = c end

            local center = ent.Position
            for i = 0, 7 do
                local angle = math.rad(discoBallAngle + i * 45)
                local px = center.X + math.cos(angle) * 60
                local py = center.Y + math.sin(angle) * 60
                if i % 3 == 0 then
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPARKLE, 0,
                        Vector(px, py), Vector.Zero, nil):SetTimeout(5)
                end
            end
        end
    end
end)

Isaac.DebugString("DiscoMode loaded! Boogie time!")
