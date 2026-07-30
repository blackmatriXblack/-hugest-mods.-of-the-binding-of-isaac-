local mod = RegisterMod("EnemyTeleportRandom", 1)
local game = Game()
local timer = 0

function mod:onUpdate()
    timer = timer + 1
    if timer % 450 >= 1 then return end
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsEnemy() and e:Exists() then
            local rx = math.random(80, 500)
            local ry = math.random(60, 380)
            e.Position = Vector(rx, ry)
            break
        end
    end
end

mod:AddCallback(5, mod.onUpdate) -- MC_POST_UPDATE
Isaac.DebugString("EnemyTeleportRandom: Random enemy teleports every 15 seconds!")
