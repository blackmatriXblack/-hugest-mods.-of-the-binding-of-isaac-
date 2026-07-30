local mod = RegisterMod("EnemyDamageScalingFloor", 1)
local level = Game():GetLevel()

function mod:onEntitySpawn(entity)
    if entity:IsEnemy() then
        local scale = 1 + level:GetChapter() * 1.0
        entity.HitPoints = entity.HitPoints * scale
    end
end

mod:AddCallback(13, mod.onEntitySpawn) -- MC_POST_ENTITY_SPAWN
Isaac.DebugString("EnemyDamageScalingFloor: Enemy HP doubles per chapter!")
