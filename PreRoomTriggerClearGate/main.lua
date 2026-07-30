-- =============================================================================
--  PreRoomTriggerClearGate - The Binding of Isaac: Repentance
--  20% chance to spawn extra enemy wave before room clear.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PreRoomTriggerClearGate", 1)

function mod:onPreRoomTriggerClear()
    -- 20% chance for bonus wave
    if math.random(1, 5) == 1 then
        local room = Game():GetRoom()
        if room == nil then return true end
        local center = room:GetCenterPos()
        -- Spawn 2-4 extra enemies as bonus wave
        local count = math.random(2, 4)
        for i = 1, count do
            local offset = Vector(math.random(-80, 80), math.random(-80, 80))
            Isaac.Spawn(EntityType.ENTITY_GAPER, 0, 0, center + offset, Vector.Zero, nil)
        end
        Isaac.DebugString("Bonus enemy wave spawned!")
    end
    return true -- allow room to clear normally
end

mod:AddCallback(ModCallbacks.MC_PRE_ROOM_TRIGGER_CLEAR, mod.onPreRoomTriggerClear)
Isaac.DebugString("PreRoomTriggerClearGate loaded!")
