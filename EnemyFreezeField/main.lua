local mod = RegisterMod("EnemyFreezeField", 1)

function mod:onNewRoom()
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsEnemy() and e:Exists() then
            e:AddFreeze(Vector(0, 0), 300)
        end
    end
end

mod:AddCallback(8, mod.onNewRoom) -- MC_POST_NEW_ROOM
Isaac.DebugString("EnemyFreezeField: All enemies frozen solid for 300 frames on room entry!")
