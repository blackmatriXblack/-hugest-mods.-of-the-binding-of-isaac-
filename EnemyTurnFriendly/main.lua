local mod = RegisterMod("EnemyTurnFriendly", 1)
local player = Isaac.GetPlayer(0)

function mod:onUpdate()
    if math.random() > 0.01 then return end
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsEnemy() and e:Exists() then
            e:AddCharm(EntityRef(player), 999999)
            break
        end
    end
end

mod:AddCallback(5, mod.onUpdate) -- MC_POST_UPDATE
Isaac.DebugString("EnemyTurnFriendly: 1% per frame chance to permanently charm a random enemy!")
