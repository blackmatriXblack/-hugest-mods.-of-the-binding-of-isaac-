-- =============================================================================
--  PostPlayerRenderAura — The Binding of Isaac: Repentance
--  MC_POST_PLAYER_RENDER: Draw a colored circle around player indicating
--  current HP percentage. Green > 50%, Yellow 25-50%, Red < 25%.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PostPlayerRenderAura", 1)

function mod:onPostPlayerRender(player, renderOffset)
    if not player:Exists() then return end

    local hpPercent = 0
    local maxHearts = player:GetMaxHearts()
    if maxHearts > 0 then
        hpPercent = player:GetHearts() / maxHearts
    end

    local color
    if hpPercent > 0.5 then
        color = Color(0.2, 1.0, 0.2, 0.6, 0, 0, 0) -- Green
    elseif hpPercent > 0.25 then
        color = Color(1.0, 1.0, 0.2, 0.6, 0, 0, 0) -- Yellow
    else
        color = Color(1.0, 0.2, 0.2, 0.6, 0, 0, 0) -- Red
    end

    local pos = Isaac.WorldToScreen(player.Position) + renderOffset
    local radius = 25

    -- Draw a filled circle around the player
    for angle = 0, 360, 5 do
        local rad = math.rad(angle)
        local px = pos.X + math.cos(rad) * radius
        local py = pos.Y + math.sin(rad) * radius

        local x2 = pos.X + math.cos(rad + math.rad(5)) * radius
        local y2 = pos.Y + math.sin(rad + math.rad(5)) * radius

        Isaac.RenderLine(Vector(px, py), Vector(x2, y2), color, 2)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.onPostPlayerRender)

Isaac.DebugString("PostPlayerRenderAura loaded!")
