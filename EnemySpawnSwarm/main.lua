local mod = RegisterMod("EnemySpawnSwarm", 1)

function mod:onNewRoom()
    local entities = Isaac.GetRoomEntities()
    local enemyCount = 0
    for _, e in ipairs(entities) do
        if e:IsEnemy() and e:Exists() then enemyCount = enemyCount + 1 end
    end
    if enemyCount < 3 then
        for i = 1, 10 do
            local pos = Vector(math.random(50, 400), math.random(50, 300))
            Isaac.Spawn(18, 0, 0, pos, Vector(0, 0), nil) -- Type 18 = Fly
        end
    end
end

mod:AddCallback(8, mod.onNewRoom) -- MC_POST_NEW_ROOM
Isaac.DebugString("EnemySpawnSwarm: Rooms with <3 enemies spawn 10 extra flies!")
