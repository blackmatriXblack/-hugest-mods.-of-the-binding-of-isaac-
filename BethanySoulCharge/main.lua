-- =============================================================================
--  BethanySoulCharge - The Binding of Isaac: Repentance
--  Bethany gains 2 extra soul charges per room cleared.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BethanySoulCharge", 1)
local prevRoomIdx = -1

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
    if player:GetPlayerType() ~= PlayerType.PLAYER_BETHANY then
        return
    end
    local room = Game():GetRoom()
    local curIdx = room:GetDecorationSeed()
    if curIdx ~= prevRoomIdx and room:IsClear() then
        prevRoomIdx = curIdx
        -- Bethany's soul charge counter; add 2 charges
        local bookVirtues = player:GetBookVirtues()
        if bookVirtues then
            bookVirtues.NextCharge = bookVirtues.NextCharge + 2
        end
    end
end)

Isaac.DebugString("BethanySoulCharge loaded!")
