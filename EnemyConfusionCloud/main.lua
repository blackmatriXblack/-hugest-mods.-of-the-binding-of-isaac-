local mod = RegisterMod("EnemyConfusionCloud", 1)
local player = Isaac.GetPlayer(0)

function mod:onNewRoom()
    if math.random() > 0.3 then return end
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsEnemy() and e:Exists() then
            e:AddConfusion(EntityRef(player), 600)
        end
    end
end

mod:AddCallback(8, mod.onNewRoom) -- MC_POST_NEW_ROOM
Isaac.DebugString("EnemyConfusionCloud: 30% chance all enemies get confused on room entry!")
