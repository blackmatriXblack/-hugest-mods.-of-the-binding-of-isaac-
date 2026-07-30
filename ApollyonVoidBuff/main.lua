-- =============================================================================
--  ApollyonVoidBuff - The Binding of Isaac: Repentance
--  Apollyon's Void always grants +1 damage per item absorbed.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ApollyonVoidBuff", 1)

mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, itemId, player)
    if itemId == CollectibleType.COLLECTIBLE_VOID
       and player:GetPlayerType() == PlayerType.PLAYER_APOLLYON then
        player:AddDamage(1) -- guaranteed +1 damage per Void use
    end
end, CollectibleType.COLLECTIBLE_VOID)

Isaac.DebugString("ApollyonVoidBuff loaded!")
