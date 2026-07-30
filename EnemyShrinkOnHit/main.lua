local mod = RegisterMod("EnemyShrinkOnHit", 1)
local player = Isaac.GetPlayer(0)

function mod:onEntityTakeDmg(entity, amount, flags, source, cooldown)
    if entity:IsEnemy() and amount > 0 then
        entity:AddShrink(EntityRef(player), 300)
    end
    return nil
end

mod:AddCallback(33, mod.onEntityTakeDmg) -- MC_ENTITY_TAKE_DMG
Isaac.DebugString("EnemyShrinkOnHit: Enemies shrink when you hit them!")
