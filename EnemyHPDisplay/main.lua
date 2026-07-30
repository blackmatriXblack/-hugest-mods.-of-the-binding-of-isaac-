-- =============================================================================
--  ENEMY HP DISPLAY — The Binding of Isaac: Repentance
--  Shows enemy HP above them using Isaac.RenderText.
--  Green → Red gradient as HP drops.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("EnemyHPDisplay", 1)

function mod:onRender()
    local room = Game():GetRoom()
    local entities = Isaac.GetRoomEntities()
    if entities == nil then return end

    for _, entity in ipairs(entities) do
        if entity:IsEnemy() and entity.HitPoints and entity.MaxHitPoints then
            local hp = entity.HitPoints
            local maxHp = entity.MaxHitPoints
            if maxHp > 0 then
                local pos = Isaac.WorldToScreen(entity.Position)
                local ratio = hp / maxHp
                -- Color gradient: green (ratio=1) → yellow (ratio=0.5) → red (ratio=0)
                local r = 1.0
                local g = ratio
                local b = 0.0
                local a = 1.0
                if ratio > 0.5 then
                    r = 2.0 - (ratio * 2.0)
                    g = 1.0
                else
                    r = 1.0
                    g = ratio * 2.0
                end
                local color = KColor(r, g, b, a)
                local text = "HP: " .. tostring(hp) .. "/" .. tostring(maxHp)
                Isaac.RenderText(text, pos.X - 30, pos.Y - 40, color, 1.0, 1.0)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("Enemy HP Display loaded!")
