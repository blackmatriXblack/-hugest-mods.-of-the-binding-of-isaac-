-- =============================================================================
--  MagdaleneHeartBonus - The Binding of Isaac: Repentance
--  Magdalene starts with +2 extra red heart containers.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MagdaleneHeartBonus", 1)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
    if player:GetPlayerType() == PlayerType.PLAYER_MAGDALENE then
        player:AddMaxHearts(4) -- +2 full heart containers (4 half-hearts)
    end
end)

Isaac.DebugString("MagdaleneHeartBonus loaded!")
