-- 30% chance to spawn a pill at room center on new room
local mod = RegisterMod("PillEffectGenerator", 1)
local game = Game()

function mod:onNewRoom()
    local itemPool = game:GetItemPool()
    local rng = RNG()

    if rng:RandomFloat() < 0.3 then
        local pillEffect = itemPool:GetPillEffect(rng:Next())
        local center = game:GetRoom():GetCenterPos()
        Isaac.Spawn(5, 70, pillEffect, center, Vector(0, 0), nil)
        Isaac.DebugString("PillEffectGenerator: Spawned pill effect " .. tostring(pillEffect))
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("PillEffectGenerator loaded! 30% chance to spawn a pill each new room.")
