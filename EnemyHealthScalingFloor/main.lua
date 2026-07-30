local mod = RegisterMod("EnemyHealthScalingFloor", 1)
local level = Game():GetLevel()

function mod:onEntitySpawn(entity)
    if entity:IsEnemy() then
        local scale = 1 + level:GetChapter() * 0.5
        entity.HitPoints = entity.HitPoints * scale
    end
end

mod:AddCallback(13, mod.onEntitySpawn) -- MC_POST_ENTITY_SPAWN
Isaac.DebugString("EnemyHealthScalingFloor: Enemy HP scales by 50% per chapter!")
