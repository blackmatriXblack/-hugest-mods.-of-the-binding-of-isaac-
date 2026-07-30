local mod = RegisterMod("EnemyProjectileReflect", 1)

function mod:onEntityTakeDmg(entity, amount, flags, source, cooldown)
    if entity:IsEnemy() and amount > 0 then
        entity:AddEntityFlags(65536)
    end
    return nil
end

mod:AddCallback(33, mod.onEntityTakeDmg) -- MC_ENTITY_TAKE_DMG
Isaac.DebugString("EnemyProjectileReflect: Enemies gain invincibility frames on hit!")
