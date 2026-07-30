local mod = RegisterMod("EnemyWeaknessScanner", 1)

function mod:onRender()
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsEnemy() and e:Exists() and e.HitPoints > 0 then
            local ratio = e.HitPoints / e.MaxHitPoints
            if ratio < 0.3 then
                local pos = Isaac.WorldToScreen(e.Position)
                Isaac.RenderText("WEAK", pos.X - 20, pos.Y - 40, 0, 0.3, 0.7, 1, 1)
            end
        end
    end
end

mod:AddCallback(4, mod.onRender) -- MC_POST_RENDER
Isaac.DebugString("EnemyWeaknessScanner: WEAK label above enemies below 30% HP!")
