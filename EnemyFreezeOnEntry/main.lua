-- EnemyFreezeOnEntry: Freezes all enemies when entering any room
local mod = RegisterMod("EnemyFreezeOnEntry", 1)

function mod:onNewRoom()
    local entities = Isaac.GetRoomEntities()
    for i, entity in ipairs(entities) do
        if entity:IsVulnerableEnemy() then
            entity.Velocity = Vector(0, 0)
            entity:AddEntityFlags(4)
        end
    end
    Isaac.DebugString("EnemyFreezeOnEntry: All enemies frozen!")
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("EnemyFreezeOnEntry loaded! Enemies freeze on room entry.")
