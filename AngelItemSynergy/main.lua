-- =============================================================================
--  AngelItemSynergy - The Binding of Isaac: Repentance
--  Having 3+ Angel room items grants a holy shield that blocks 1 hit per room
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("AngelItemSynergy", 1)

local angelItems = {
    CollectibleType.COLLECTIBLE_HOLY_MANTLE,
    CollectibleType.COLLECTIBLE_THE_HALO,
    CollectibleType.COLLECTIBLE_DEAD_DOVE,
    CollectibleType.COLLECTIBLE_SACRED_HEART,
    CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT,
    CollectibleType.COLLECTIBLE_GODHEAD,
    CollectibleType.COLLECTIBLE_CELTIC_CROSS,
    CollectibleType.COLLECTIBLE_GUARDIAN_ANGEL,
    CollectibleType.COLLECTIBLE_HOLY_LIGHT,
    CollectibleType.COLLECTIBLE_HOLY_WATER,
    CollectibleType.COLLECTIBLE_SWORN_PROTECTOR,
    CollectibleType.COLLECTIBLE_IMMACULATE_CONCEPTION,
    CollectibleType.COLLECTIBLE_DIVINE_INTERVENTION,
    CollectibleType.COLLECTIBLE_VADE_RETRO,
    CollectibleType.COLLECTIBLE_SALVATION,
    CollectibleType.COLLECTIBLE_JESUS_JUICE,
    CollectibleType.COLLECTIBLE_STIGMATA,
    CollectibleType.COLLECTIBLE_BLOOD_OF_THE_MARTYR,
    CollectibleType.COLLECTIBLE_PRAYER_CARD,
    CollectibleType.COLLECTIBLE_BIBLE,
    CollectibleType.COLLECTIBLE_SCAPULAR,
    CollectibleType.COLLECTIBLE_MITRE,
    CollectibleType.COLLECTIBLE_ROSARY,
    CollectibleType.COLLECTIBLE_TRINITY_SHIELD,
    CollectibleType.COLLECTIBLE_SPIRIT_SWORD,
    CollectibleType.COLLECTIBLE_HALLOWED_GROUND,
    CollectibleType.COLLECTIBLE_GLYPH_OF_BALANCE,
    CollectibleType.COLLECTIBLE_PURITY,
    CollectibleType.COLLECTIBLE_URIEL,
    CollectibleType.COLLECTIBLE_GABRIEL,
}

local shieldsUsed = {}

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    local count = 0
    for _, id in ipairs(angelItems) do
        if player:HasCollectible(id) then count = count + 1 end
    end
    local idx = GetPtrHash(player)
    if count >= 3 then
        if not shieldsUsed[idx] then
            -- Grant Holy Mantle effect for 1 hit
            player:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE, false, 1)
            shieldsUsed[idx] = true
        end
    else
        shieldsUsed[idx] = nil
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    shieldsUsed = {}
end)

Isaac.DebugString("AngelItemSynergy loaded!")
