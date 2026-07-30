-- =============================================================================
--  AzazelWingBuff - The Binding of Isaac: Repentance
--  Azazel starts with 1.5x range on his brimstone beam.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("AzazelWingBuff", 1)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
    if player:GetPlayerType() == PlayerType.PLAYER_AZAZEL then
        player.TearRange = player.TearRange * 1.5
    end
end)

Isaac.DebugString("AzazelWingBuff loaded!")
