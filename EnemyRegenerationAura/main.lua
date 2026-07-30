local mod = RegisterMod("EnemyRegenerationAura", 1)
local timer = 0

function mod:onUpdate()
    timer = timer + 1
    if timer % 60 >= 1 then return end
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsEnemy() and e:Exists() and e.HitPoints > 0 then
            e.HitPoints = math.min(e.MaxHitPoints, e.HitPoints + 2)
        end
    end
end

mod:AddCallback(5, mod.onUpdate) -- MC_POST_UPDATE
Isaac.DebugString("EnemyRegenerationAura: All enemies heal 2 HP every 2 seconds!")
