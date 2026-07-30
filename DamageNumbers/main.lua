-- ==========================================================================
--  DamageNumbers - The Binding of Isaac: Repentance
--  RPG-style damage numbers pop up from enemies when hit!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("DamageNumbers", 1)
local DAMAGE_TEXTS = {}

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, countdown)
    if entity:IsVulnerableEnemy() and amount > 0 then
        local x = entity.Position.X + math.random(-15, 15)
        local y = entity.Position.Y - 20 - math.random(0, 10)
        local crit = flags & DamageFlag.DAMAGE_TEAR ~= 0 and amount > 15

        table.insert(DAMAGE_TEXTS, {
            text = tostring(math.floor(amount)),
            x = x, y = y,
            timer = 0,
            maxTimer = 30,
            alpha = 1,
            offsetY = 0,
            r = crit and 1 or 1,
            g = crit and 0.3 or 1,
            b = crit and 0 or 0.3,
            scale = crit and 1.8 or 1.2
        })
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local toRemove = {}
    for i, dt in ipairs(DAMAGE_TEXTS) do
        dt.timer = dt.timer + 1
        dt.offsetY = dt.timer * 1.2
        dt.alpha = 1 - dt.timer / dt.maxTimer

        if dt.timer >= dt.maxTimer then
            table.insert(toRemove, i)
        else
            local screenPos = Isaac.WorldToScreen(Vector(dt.x, dt.y - dt.offsetY))
            Isaac.RenderText(dt.text,
                screenPos.X - 15, screenPos.Y,
                dt.r, dt.g, dt.b, dt.alpha, dt.scale)
        end
    end
    for i = #toRemove, 1, -1 do
        table.remove(DAMAGE_TEXTS, toRemove[i])
    end
end)

Isaac.DebugString("DamageNumbers loaded! Numbers go BRRR!")
