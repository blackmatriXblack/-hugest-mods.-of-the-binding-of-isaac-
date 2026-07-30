-- =============================================================================
--  LostHolyCard - The Binding of Isaac: Repentance
--  The Lost starts with 2 Holy Cards instead of only 1.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("LostHolyCard", 1)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
    if player:GetPlayerType() == PlayerType.PLAYER_THELOST then
        player:AddCard(Card.CARD_HOLY)
    end
end)

Isaac.DebugString("LostHolyCard loaded!")
