-- =============================================================================
--  CainLuckyFoot - The Binding of Isaac: Repentance
--  Cain gets an additional +3 Luck, stacking with Lucky Foot.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CainLuckyFoot", 1)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
    if player:GetPlayerType() == PlayerType.PLAYER_CAIN then
        player:AddLuck(3)
    end
end)

Isaac.DebugString("CainLuckyFoot loaded!")
