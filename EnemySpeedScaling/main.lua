local mod = RegisterMod("EnemySpeedScaling", 1)
local level = Game():GetLevel()

function mod:onEntitySpawn(entity)
    if entity:IsEnemy() then
        local scale = 1 + level:GetChapter() * 0.2
        entity.Velocity = entity.Velocity * scale
    end
end

mod:AddCallback(13, mod.onEntitySpawn) -- MC_POST_ENTITY_SPAWN
Isaac.DebugString("EnemySpeedScaling: Enemy speed scales with floor chapter!")
