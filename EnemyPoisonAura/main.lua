local mod = RegisterMod("EnemyPoisonAura", 1)
local game = Game()
local player = Isaac.GetPlayer(0)
local timer = 0

function mod:onUpdate()
    timer = timer + 1
    if timer % 150 >= 1 then return end
    local room = game:GetLevel():GetCurrentRoom()
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsEnemy() and e:Exists() then
            e:AddPoison(EntityRef(player), 300, 3)
        end
    end
end

mod:AddCallback(5, mod.onUpdate) -- MC_POST_UPDATE
Isaac.DebugString("EnemyPoisonAura: All enemies take poison DoT every 5 seconds!")
