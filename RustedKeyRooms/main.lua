-- =============================================================================
--  RustedKeyRooms - The Binding of Isaac: Repentance
--  Rusted Key trinket reveals 2 extra rooms on the map instead of 1
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RustedKeyRooms", 1)
local TRINKET_RUSTED_KEY = 37

function mod:onNewLevel()
    local player = Isaac.GetPlayer(0)
    if not player or not player:HasTrinket(TRINKET_RUSTED_KEY) then return end

    local level = Game():GetLevel()
    local rooms = level:GetRooms()
    local revealed = 0

    for i = 0, rooms.Size - 1 do
        local roomDesc = rooms:Get(i)
        if roomDesc and roomDesc.DisplayFlags == 0 then
            roomDesc.DisplayFlags = 5
            revealed = revealed + 1
            if revealed >= 2 then break end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
Isaac.DebugString("RustedKeyRooms loaded!")
