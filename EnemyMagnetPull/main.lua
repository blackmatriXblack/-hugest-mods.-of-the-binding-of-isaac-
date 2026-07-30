local mod = RegisterMod("EnemyMagnetPull", 1)
local player = Isaac.GetPlayer(0)

function mod:onUpdate()
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsEnemy() and e:Exists() then
            local dist = (e.Position - player.Position):Length()
            if dist < 300 and dist > 0 then
                local dir = (player.Position - e.Position):Normalized()
                e.Velocity = dir * 2
            end
        end
    end
end

mod:AddCallback(5, mod.onUpdate) -- MC_POST_UPDATE
Isaac.DebugString("EnemyMagnetPull: Enemies within 300 range pulled toward player!")
