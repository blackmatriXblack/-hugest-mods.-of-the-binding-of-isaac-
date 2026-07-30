local mod = RegisterMod("EnemySizeOscillation", 1)
local game = Game()

function mod:onUpdate()
    local frame = game:GetFrameCount()
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsEnemy() and e:Exists() then
            local s = math.sin(frame * 0.05)
            e.Scale = 1.25 + s * 0.75
        end
    end
end

mod:AddCallback(5, mod.onUpdate) -- MC_POST_UPDATE
Isaac.DebugString("EnemySizeOscillation: Enemy sizes oscillate between 0.5 and 2.0!")
