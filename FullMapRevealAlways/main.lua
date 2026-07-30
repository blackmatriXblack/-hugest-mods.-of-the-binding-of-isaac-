-- =============================================================================
--  FULL MAP REVEAL ALWAYS — The Binding of Isaac: Repentance
--  Always see the full floor map, including secret rooms.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FullMapRevealAlways", 1)
local mapRevealed = false

function mod:onUpdate()
    local player = Isaac.GetPlayer(0)
    if player == nil then return end
    local level = Game():GetLevel()
    if level == nil then return end

    -- Reveal all rooms on the current level
    for i = 0, level:GetNumRooms() - 1 do
        local roomDesc = level:GetRoomByIdx(i)
        if roomDesc ~= nil then
            roomDesc.Visible = true
            if roomDesc.Flags and roomDesc.Flags & 1 == 0 then
                roomDesc.Flags = roomDesc.Flags | 1
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("Full Map Reveal Always loaded! Entire map is visible.")
