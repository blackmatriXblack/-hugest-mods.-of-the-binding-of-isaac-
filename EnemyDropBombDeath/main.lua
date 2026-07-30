local mod = RegisterMod("EnemyDropBombDeath", 1)

function mod:onEntityKill(entity)
    if entity:IsEnemy() then
        Isaac.Spawn(5, 40, 4, entity.Position, Vector(0, 0), nil) -- Type 5=Pickup, Var 40=Bomb
    end
end

mod:AddCallback(68, mod.onEntityKill) -- MC_POST_ENTITY_KILL
Isaac.DebugString("EnemyDropBombDeath: All killed enemies drop a bomb!")
