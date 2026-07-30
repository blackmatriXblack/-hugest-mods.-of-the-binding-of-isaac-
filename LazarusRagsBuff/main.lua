-- =============================================================================
--  LazarusRagsBuff - The Binding of Isaac: Repentance
--  Lazarus Rags revive grants +2 to all stats on resurrection.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("LazarusRagsBuff", 1)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
    if player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2 then
        player:AddDamage(2)
        player:AddTears(2)
        player:AddRange(2)
        player:AddSpeed(0.2)
        player:AddLuck(2)
    end
end)

Isaac.DebugString("LazarusRagsBuff loaded!")
