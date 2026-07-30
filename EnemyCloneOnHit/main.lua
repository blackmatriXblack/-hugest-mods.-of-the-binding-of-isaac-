local mod = RegisterMod("EnemyCloneOnHit", 1)

function mod:onEntityTakeDmg(entity, amount, flags, source, cooldown)
    if entity:IsEnemy() and amount > 0 and math.random() < 0.15 then
        local ox = math.random() * 40 - 20
        local oy = math.random() * 40 - 20
        local pos = entity.Position + Vector(ox, oy)
        Isaac.Spawn(entity.Type, entity.Variant, entity.SubType, pos, Vector(0, 0), nil)
    end
    return nil
end

mod:AddCallback(33, mod.onEntityTakeDmg) -- MC_ENTITY_TAKE_DMG
Isaac.DebugString("EnemyCloneOnHit: 15% chance enemies clone on hit!")
