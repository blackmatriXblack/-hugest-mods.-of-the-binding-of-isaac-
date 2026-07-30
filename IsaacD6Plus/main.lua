-- =============================================================================
--  IsaacD6Plus - The Binding of Isaac: Repentance
--  Isaac's D6 recharges in 2 rooms instead of 6 for faster rerolls.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("IsaacD6Plus", 1)

-- Set D6 charge to max-2 after Isaac uses it (needs only 2 rooms to refill)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, function(_, itemId, player)
    if player:GetPlayerType() == PlayerType.PLAYER_ISAAC
       and itemId == CollectibleType.COLLECTIBLE_D6 then
        local maxCharge = player:GetActiveMaxCharge(ActiveSlot.SLOT_PRIMARY)
        player:SetActiveCharge(maxCharge - 2, ActiveSlot.SLOT_PRIMARY)
    end
end, CollectibleType.COLLECTIBLE_D6)

Isaac.DebugString("IsaacD6Plus loaded!")
