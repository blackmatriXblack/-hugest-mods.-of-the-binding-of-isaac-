local mod = RegisterMod("EnemyExplodeOnDeath", 1)

function mod:onEntityKill(entity)
    if entity:IsEnemy() and math.random() < 0.4 then
        local entities = Isaac.GetRoomEntities()
        for _, e in ipairs(entities) do
            if e ~= entity and e:IsEnemy() and e:Exists() then
                local dist = (e.Position - entity.Position):Length()
                if dist < 100 then
                    e:TakeDamage(30, 0, EntityRef(entity), 0)
                end
            end
        end
    end
end

mod:AddCallback(68, mod.onEntityKill) -- MC_POST_ENTITY_KILL
Isaac.DebugString("EnemyExplodeOnDeath: 40% chance enemy death deals 30 damage to nearby enemies!")
