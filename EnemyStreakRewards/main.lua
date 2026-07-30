local mod = RegisterMod("EnemyStreakRewards", 1)
local killCount = 0

function mod:onEntityKill(entity)
    if entity:IsEnemy() then
        killCount = killCount + 1
        if killCount % 10 == 0 then
            Isaac.Spawn(5, 100, 25, entity.Position, Vector(0, 0), nil) -- Pedestal item
        end
    end
end

mod:AddCallback(68, mod.onEntityKill) -- MC_POST_ENTITY_KILL
Isaac.DebugString("EnemyStreakRewards: Every 10 kills spawn a pedestal item!")
