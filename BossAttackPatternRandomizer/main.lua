local mod = RegisterMod("BossAttackPatternRandomizer", 1)

function mod:onNewRoom()
    local room = Game():GetLevel():GetCurrentRoom()
    if room:GetType() ~= 3 then return end
    local entities = Isaac.GetRoomEntities()
    local rndFlags = {1, 4, 256, 1024, 65536}
    for _, e in ipairs(entities) do
        if e:IsBoss() and e:Exists() then
            local f = rndFlags[math.random(1, #rndFlags)]
            e:AddEntityFlags(f)
        end
    end
end

mod:AddCallback(8, mod.onNewRoom) -- MC_POST_NEW_ROOM
Isaac.DebugString("BossAttackPatternRandomizer: Bosses get random flags to change attacks!")
