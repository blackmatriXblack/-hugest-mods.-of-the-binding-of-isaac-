local mod = RegisterMod("EnemyReverseControls", 1)
local player = Isaac.GetPlayer(0)

function mod:onUpdate()
    local entities = Isaac.GetRoomEntities()
    local nearEnemy = false
    for _, e in ipairs(entities) do
        if e:IsEnemy() and e:Exists() then
            local dist = (e.Position - player.Position):Length()
            if dist < 200 then nearEnemy = true; break end
        end
    end
    if nearEnemy then
        player.Velocity = player.Velocity * -0.5
    end
end

mod:AddCallback(5, mod.onUpdate) -- MC_POST_UPDATE
Isaac.DebugString("EnemyReverseControls: Player velocity reversed when enemies are near!")
