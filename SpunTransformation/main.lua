-- =============================================================================
--  SpunTransformation - The Binding of Isaac: Repentance
--  Spun transformation grants immunity to slowing effects and creep damage
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SpunTransformation", 1)

local spunItems = {
    CollectibleType.COLLECTIBLE_SYNTHOIL,
    CollectibleType.COLLECTIBLE_EXPERIMENTAL_TREATMENT,
    CollectibleType.COLLECTIBLE_THE_VIRUS,
    CollectibleType.COLLECTIBLE_GROWTH_HORMONES,
    CollectibleType.COLLECTIBLE_SPEED_BALL,
    CollectibleType.COLLECTIBLE_ADRENALINE,
}

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    local count = 0
    for _, id in ipairs(spunItems) do
        if player:HasCollectible(id) then count = count + 1 end
    end
    if count >= 3 then
        if player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_CALLUS) == 0 then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_CALLUS, false, 1)
        end
    end
end)

Isaac.DebugString("SpunTransformation loaded!")
