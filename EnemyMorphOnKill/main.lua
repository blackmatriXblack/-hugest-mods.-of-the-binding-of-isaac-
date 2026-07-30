local mod = RegisterMod("EnemyMorphOnKill", 1)

function mod:onEntityKill(entity)
    if entity:IsEnemy() and math.random() < 0.2 then
        local pos = entity.Position
        local newType = entity.Type + 1
        if newType > 100 then newType = 22 end -- fallback to Gaper
        Isaac.Spawn(newType, 0, 0, pos, Vector(0, 0), nil)
    end
end

mod:AddCallback(68, mod.onEntityKill) -- MC_POST_ENTITY_KILL
Isaac.DebugString("EnemyMorphOnKill: 20% chance killed enemies spawn a stronger enemy!")
