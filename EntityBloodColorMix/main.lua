local mod = RegisterMod("EntityBloodColorMix", 1)

function mod:onEntitySpawn(entity)
    if entity:IsEnemy() then
        entity.BloodColor = Color(1, 0, 0, 1, 0.5, 0, 0)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onEntitySpawn)
