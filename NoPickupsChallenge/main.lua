-- ==========================================================================
--  No Pickups Challenge - The Binding of Isaac: Repentance
--  All pickups converted to nothing — only items (pedestals) can be collected
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("NoPickupsChallenge", 1)
local game = Game()

local removablePickups = {
    [EntityType.ENTITY_PICKUP] = {
        PickupVariant.PICKUP_HEART,
        PickupVariant.PICKUP_COIN,
        PickupVariant.PICKUP_KEY,
        PickupVariant.PICKUP_BOMB,
        PickupVariant.PICKUP_LIL_BATTERY,
        PickupVariant.PICKUP_PILL,
        PickupVariant.PICKUP_TAROTCARD,
        PickupVariant.PICKUP_SACK,
        PickupVariant.PICKUP_CHEST,
    }
}

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, function(_, entity)
    if entity.Type ~= EntityType.ENTITY_PICKUP then return end

    local isRemovable = false
    for _, variant in ipairs(removablePickups[EntityType.ENTITY_PICKUP] or {}) do
        if entity.Variant == variant then
            isRemovable = true
            break
        end
    end

    if isRemovable then
        -- Poof effect instead of pickup
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02,
            0, entity.Position, Vector.Zero, nil)
        entity:Remove()
    end
end)

Isaac.DebugString("No Pickups Challenge loaded!")
