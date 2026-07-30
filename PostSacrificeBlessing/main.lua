-- =============================================================================
--  PostSacrificeBlessing - The Binding of Isaac: Repentance
--  30% chance to spawn random card and displays blessing tier after sacrifice.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PostSacrificeBlessing", 1)
local blessingText = ""
local blessingTimer = 0

function mod:onPostSacrifice(player, numSacrifices)
    blessingTimer = 120
    blessingText = "Blessing Tier: " .. numSacrifices

    -- 30% chance for bonus card
    if math.random(1, 100) <= 30 then
        local cardTypes = {
            Card.CARD_FOOL, Card.CARD_MAGICIAN, Card.CARD_HIGH_PRIESTESS,
            Card.CARD_EMPRESS, Card.CARD_EMPEROR, Card.CARD_HIEROPHANT,
            Card.CARD_LOVERS, Card.CARD_CHARIOT, Card.CARD_JUSTICE,
            Card.CARD_HERMIT, Card.CARD_WHEEL_OF_FORTUNE, Card.CARD_STRENGTH,
            Card.CARD_HANGED_MAN, Card.CARD_DEATH, Card.CARD_TEMPERANCE,
            Card.CARD_DEVIL, Card.CARD_TOWER, Card.CARD_STARS,
            Card.CARD_MOON, Card.CARD_SUN, Card.CARD_JUDGEMENT, Card.CARD_WORLD
        }
        local cardType = cardTypes[math.random(1, #cardTypes)]
        local cardPos = player.Position + Vector(0, -40)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, cardType, cardPos, Vector(0, -2), nil)
    end
end

function mod:onPostRender()
    if blessingTimer <= 0 then return end
    blessingTimer = blessingTimer - 1
    Isaac.RenderText(blessingText, 60, 100, 0.5, 1, 0.5, 1)
end

mod:AddCallback(ModCallbacks.MC_POST_SACRIFICE, mod.onPostSacrifice)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("PostSacrificeBlessing loaded!")
