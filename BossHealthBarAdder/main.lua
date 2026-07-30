local mod = RegisterMod("BossHealthBarAdder", 1)

function mod:onEntitySpawn(entity)
    if entity:IsBoss() then
        entity:AddBossHealthBar()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onEntitySpawn)
