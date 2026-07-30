-- =============================================================================
--  RoomCountSummary — The Binding of Isaac: Repentance
--  Show total rooms explored / total rooms on floor in HUD.
--  Version: 1.0   | Official API only
-- =============================================================================

local mod = RegisterMod("RoomCountSummary", 1)
local game = Game()
mod.exploredRooms = 0
mod.totalRooms = 0

function mod:onNewRoom()
    local level = game:GetLevel()
    local rooms = level:GetRooms()
    if not rooms then return end

    local count = rooms:Size()
    mod.totalRooms = count

    -- Count explored rooms (rooms with DisplayFlags indicating visited)
    local explored = 0
    for i = 0, count - 1 do
        local roomDesc = rooms:Get(i)
        if roomDesc and (roomDesc.DisplayFlags & 1) ~= 0 then -- visited flag
            explored = explored + 1
        end
    end
    mod.exploredRooms = explored
end

function mod:onPostRender()
    local text = "Rooms Explored: " .. tostring(mod.exploredRooms) ..
                 " / " .. tostring(mod.totalRooms)
    Isaac.RenderText(text, 10, 158, 0.8, 0.8, 0.7, 1, 0.7)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("RoomCountSummary loaded!")
