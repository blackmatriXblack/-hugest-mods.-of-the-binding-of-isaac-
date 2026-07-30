local mod = RegisterMod("BossEnrageLowHP", 1)
local game = Game()

function mod:onUpdate()
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsBoss() and e:Exists() then
            if e.HitPoints < e.MaxHitPoints * 0.3 and e.HitPoints > 0 then
                e.HitPoints = e.MaxHitPoints
                e:AddEntityFlags(1)
                Isaac.DebugString("BOSS ENRAGED!")
            end
        end
    end
end

mod:AddCallback(5, mod.onUpdate) -- MC_POST_UPDATE
Isaac.DebugString("BossEnrageLowHP: Bosses heal and enrage below 30% HP!")
