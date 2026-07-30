-- ==========================================================================
--  Timed Rooms - The Binding of Isaac: Repentance
--  Each room has a 30-second timer — doors lock and enemies double if time runs out
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TimedRooms", 1)
local game = Game()
local roomTimer = 0
local timerExpired = false
local TIMER_MAX = 900 -- 30 seconds * 30 fps

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    roomTimer = 0
    timerExpired = false
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if timerExpired then return end
    roomTimer = roomTimer + 1

    if roomTimer >= TIMER_MAX then
        timerExpired = true
        local room = game:GetRoom()

        -- Lock all doors
        for i = 0, DoorSlot.NUM_DOOR_SLOTS - 1 do
            local door = room:GetDoor(i)
            if door then
                room:SetDoorState(i, DoorState.STATE_LOCKED)
            end
        end

        -- Double all enemies (spawn a clone of each)
        local entities = Isaac.GetRoomEntities()
        for _, ent in ipairs(entities) do
            if ent:IsEnemy() then
                local clone = Isaac.Spawn(ent.Type, ent.Variant, ent.SubType,
                    ent.Position + Vector(math.random(-40, 40), math.random(-40, 40)),
                    Vector.Zero, nil)
                if clone then
                    clone.HitPoints = ent.HitPoints
                end
            end
        end

        Isaac.DebugString("TIME'S UP! Doors locked, enemies doubled!")
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if not timerExpired then
        local remaining = math.max(0, TIMER_MAX - roomTimer)
        local seconds = math.ceil(remaining / 30)
        Isaac.RenderText(string.format("%ds", seconds),
            60, 20, 1, 1, 1, 1)
    end
end)

Isaac.DebugString("Timed Rooms loaded!")
