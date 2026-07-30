-- =============================================================================
--  CardBonusEffect — The Binding of Isaac: Repentance
--  Using any card also gives +0.5 damage for the room.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CardBonusEffect", 1)

function mod:onUseCard(cardType)
    local player = Isaac.GetPlayer(0)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:AddDamage(0.5, 0, EntityType.ENTITY_PLAYER, false)
    Isaac.DebugString("Card bonus: +0.5 damage for room")
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.onUseCard)
Isaac.DebugString("CardBonusEffect loaded!")
