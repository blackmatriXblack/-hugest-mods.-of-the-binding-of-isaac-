-- EnemySlower: Reduces all enemy movement speed to 30% every frame
local mod = RegisterMod("EnemySlower", 1)

function mod:onUpdate()
    local entities = Isaac.GetRoomEntities()
    for i, entity in ipairs(entities) do
        if entity:IsVulnerableEnemy() then
            entity.Velocity = entity.Velocity * 0.3
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("EnemySlower loaded! Enemies move at 30% speed.")
