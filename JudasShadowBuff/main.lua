-- =============================================================================
--  JudasShadowBuff - The Binding of Isaac: Repentance
--  Dark Judas revived via Judas' Shadow gets +2 bonus damage.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("JudasShadowBuff", 1)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
    if player:GetPlayerType() == PlayerType.PLAYER_DARKJUDAS then
        player:AddDamage(2)
    end
end)

Isaac.DebugString("JudasShadowBuff loaded!")
