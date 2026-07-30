-- =============================================================================
--  BlueBabySoulHearts - The Binding of Isaac: Repentance
--  Blue Baby starts with 5 soul hearts instead of the default 3.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BlueBabySoulHearts", 1)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
    if player:GetPlayerType() == PlayerType.PLAYER_BLUEBABY then
        player:AddSoulHearts(4) -- +2 soul hearts (4 half-soul-hearts) => 5 total
    end
end)

Isaac.DebugString("BlueBabySoulHearts loaded!")
