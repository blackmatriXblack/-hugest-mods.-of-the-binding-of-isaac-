local mod = RegisterMod("EliteChampionMadness", 1)

function mod:onEntitySpawn(entity)
    if entity:IsEnemy() and math.random() < 0.3 then
        entity:AddEntityFlags(1)
        entity:AddEntityFlags(4)
        entity.HitPoints = entity.HitPoints * 2
    end
end

mod:AddCallback(13, mod.onEntitySpawn) -- MC_POST_ENTITY_SPAWN
Isaac.DebugString("EliteChampionMadness: 30% chance enemies become champions with double HP!")
