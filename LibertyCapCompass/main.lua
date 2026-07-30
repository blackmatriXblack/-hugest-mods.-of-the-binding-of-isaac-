-- =============================================================================
--  LibertyCapCompass - The Binding of Isaac: Repentance
--  Liberty Cap trinket also reveals the map layout like the Compass
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("LibertyCapCompass", 1)
local TRINKET_LIBERTY_CAP = 27

function mod:onNewRoom()
    local player = Isaac.GetPlayer(0)
    if not player or not player:HasTrinket(TRINKET_LIBERTY_CAP) then return end

    local level = Game():GetLevel()
    local rooms = level:GetRooms()

    for i = 0, rooms.Size - 1 do
        local roomDesc = rooms:Get(i)
        if roomDesc then
            roomDesc.DisplayFlags = 5
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("LibertyCapCompass loaded!")
