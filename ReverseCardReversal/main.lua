-- =============================================================================
--  ReverseCardReversal — The Binding of Isaac: Repentance
--  Reverse cards have a 15% chance to trigger their normal counterpart effect too.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ReverseCardReversal", 1)

local REVERSE_TO_NORMAL = {
    [Card.CARD_REVERSE_MAGICIAN] = Card.CARD_MAGICIAN,
    [Card.CARD_REVERSE_HIGH_PRIESTESS] = Card.CARD_HIGH_PRIESTESS,
    [Card.CARD_REVERSE_EMPRESS] = Card.CARD_EMPRESS,
    [Card.CARD_REVERSE_EMPEROR] = Card.CARD_EMPEROR,
    [Card.CARD_REVERSE_HIEROPHANT] = Card.CARD_HIEROPHANT,
    [Card.CARD_REVERSE_LOVERS] = Card.CARD_LOVERS,
    [Card.CARD_REVERSE_CHARIOT] = Card.CARD_CHARIOT,
    [Card.CARD_REVERSE_JUSTICE] = Card.CARD_JUSTICE,
    [Card.CARD_REVERSE_HERMIT] = Card.CARD_HERMIT,
    [Card.CARD_REVERSE_WHEEL_OF_FORTUNE] = Card.CARD_WHEEL_OF_FORTUNE,
    [Card.CARD_REVERSE_STRENGTH] = Card.CARD_STRENGTH,
    [Card.CARD_REVERSE_HANGED_MAN] = Card.CARD_HANGED_MAN,
    [Card.CARD_REVERSE_DEATH] = Card.CARD_DEATH,
    [Card.CARD_REVERSE_TEMPERANCE] = Card.CARD_TEMPERANCE,
    [Card.CARD_REVERSE_DEVIL] = Card.CARD_DEVIL,
    [Card.CARD_REVERSE_TOWER] = Card.CARD_TOWER,
    [Card.CARD_REVERSE_STARS] = Card.CARD_STARS,
    [Card.CARD_REVERSE_MOON] = Card.CARD_MOON,
    [Card.CARD_REVERSE_SUN] = Card.CARD_SUN,
    [Card.CARD_REVERSE_JUDGEMENT] = Card.CARD_JUDGEMENT,
    [Card.CARD_REVERSE_WORLD] = Card.CARD_WORLD,
    [Card.CARD_REVERSE_FOOL] = Card.CARD_FOOL,
}

function mod:OnUseCard(card, player, flags)
    local normalCard = REVERSE_TO_NORMAL[card]
    if not normalCard then return end

    local rng = RNG()
    rng:SetSeed(player:GetDropRNG():Next(), 0)

    if rng:RandomFloat() < 0.15 then
        player:UseCard(normalCard)
        Isaac.DebugString("ReverseCardReversal triggered!")
    end
end

mod:AddCallback(ModCallbacks.MC_USE_CARD, mod.OnUseCard)
Isaac.DebugString("ReverseCardReversal loaded!")
