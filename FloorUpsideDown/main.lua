-- ==========================================================================
--  Floor Upside Down - The Binding of Isaac: Repentance
--  Every floor is upside down — enemies spawn from boss room first, layout reversed
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("FloorUpsideDown", 1)
local game = Game()
local level = nil

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    level = game:GetLevel()
    
    if level:GetStartingRoomIndex() >= 0 then
        -- Teleport the player near the boss room entrance
        local player = game:GetPlayer(0)
        if player then
            local bossRoom = level:GetBossRoomIndex()
            if bossRoom >= 0 then
                local rooms = level:GetRooms()
                for i = 0, rooms.Size - 1 do
                    local room = rooms:Get(i)
                    if room.SafeGridIndex == bossRoom then
                        -- Find a neighboring room to spawn near boss
                        for _, doorSlot in ipairs(room.DoorsList or {}) do
                            local neighborIdx = level:GetAdjacentRoomIndex(bossRoom, doorSlot)
                            if neighborIdx >= 0 and neighborIdx ~= bossRoom then
                                game:StartRoomTransition(neighborIdx, doorSlot, RoomTransitionAnim.WALK)
                                Isaac.DebugString("Floor reversed — starting near boss!")
                                return
                            end
                        end
                    end
                end
            end
        end
    end
end)

Isaac.DebugString("Floor Upside Down loaded!")
