local mod = RegisterMod("BossMinionSpawner", 1)
local game = Game()
local timer = 0

function mod:onUpdate()
    local room = game:GetLevel():GetCurrentRoom()
    if room:GetType() ~= 3 then timer = 0; return end
    timer = timer + 1
    if timer % 300 >= 1 then return end
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsBoss() and e:Exists() then
            local pos = e.Position + Vector(math.random(-40, 40), math.random(-40, 40))
            Isaac.Spawn(18, 0, 0, pos, Vector(0, 0), e) -- Type 18 = Attack Fly
            Isaac.Spawn(18, 0, 0, e.Position + Vector(math.random(-40, 40), math.random(-40, 40)), Vector(0, 0), e)
            break
        end
    end
end

mod:AddCallback(5, mod.onUpdate) -- MC_POST_UPDATE
Isaac.DebugString("BossMinionSpawner: Bosses spawn 2 attack flies every 10 seconds!")
