-- =============================================================================
--  MinimapFullReveal — The Binding of Isaac: Repentance
--  Minimap shows all rooms including secret rooms (mapped, not revealed).
--  Version: 1.0   | Official API only
-- =============================================================================

local mod = RegisterMod("MinimapFullReveal", 1)
local game = Game()

function mod:onNewRoom()
    local level = game:GetLevel()
    local currentRoomDesc = level:GetCurrentRoomDesc()
    if not currentRoomDesc then return end

    -- Reveal the entire minimap for the current floor (rooms are mapped but not fully revealed)
    local numRooms = level:GetRooms():Size()
    local roomDescs = level:GetRooms()
    for i = 0, numRooms - 1 do
        local roomDesc = roomDescs:Get(i)
        if roomDesc then
            roomDesc.DisplayFlags = roomDesc.DisplayFlags | 2 -- mark as visible on minimap
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("MinimapFullReveal loaded!")
