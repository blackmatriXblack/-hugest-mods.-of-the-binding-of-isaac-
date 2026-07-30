local mod = RegisterMod("BossDoubleTrouble", 1)
local spawned = false

function mod:onNewRoom()
    spawned = false
    local room = Game():GetLevel():GetCurrentRoom()
    if room:GetType() ~= 3 then return end
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsBoss() and e:Exists() and not spawned then
            local pos = e.Position + Vector(60, 0)
            Isaac.Spawn(e.Type, e.Variant, e.SubType, pos, Vector(0, 0), nil)
            spawned = true
        end
    end
end

mod:AddCallback(8, mod.onNewRoom) -- MC_POST_NEW_ROOM
Isaac.DebugString("BossDoubleTrouble: Boss rooms now have double the bosses!")
