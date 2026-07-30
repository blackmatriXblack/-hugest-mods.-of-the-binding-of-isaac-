local mod = RegisterMod("EnemyCharmChance", 1)
local game = Game()
local player = Isaac.GetPlayer(0)
local timer = 0

function mod:onUpdate()
    timer = timer + 1
    if timer % 300 >= 1 then return end
    if math.random() > 0.2 then return end
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsEnemy() and e:Exists() then
            e:AddCharm(EntityRef(player), 300)
            break
        end
    end
end

mod:AddCallback(5, mod.onUpdate) -- MC_POST_UPDATE
Isaac.DebugString("EnemyCharmChance: 20% chance every 10s to charm a random enemy!")
