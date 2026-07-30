local mod = RegisterMod("EnemyFearAura", 1)
local game = Game()
local player = Isaac.GetPlayer(0)
local timer = 0

function mod:onUpdate()
    timer = timer + 1
    if timer % 240 >= 1 then return end
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsEnemy() and e:Exists() then
            local dist = (e.Position - player.Position):Length()
            if dist < 150 then
                e:AddFear(EntityRef(player), 180)
            end
        end
    end
end

mod:AddCallback(5, mod.onUpdate) -- MC_POST_UPDATE
Isaac.DebugString("EnemyFearAura: Nearby enemies (dist<150) get feared every 8 seconds!")
