local mod = RegisterMod("EnemyRageMode", 1)
local game = Game()

function mod:onEntitySpawn(entity)
    if entity:IsEnemy() then
        entity:AddEntityFlags(1)
        entity.HitPoints = entity.HitPoints * 2
    end
end

mod:AddCallback(13, mod.onEntitySpawn) -- MC_POST_ENTITY_SPAWN
Isaac.DebugString("EnemyRageMode: All enemies are now aggressive with double HP!")
