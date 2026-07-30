-- =============================================================================
--  Mimic Chest Chaos - The Binding of Isaac: Repentance
--  50% of all chests are actually mimics!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MimicChestChaos", 1)

function mod:onEntitySpawn(entity)
    if entity.Type == EntityType.ENTITY_PICKUP then
        local variant = entity.Variant
        -- Check if it's a chest
        if variant == PickupVariant.PICKUP_CHEST or
           variant == PickupVariant.PICKUP_BOMBCHEST or
           variant == PickupVariant.PICKUP_LOCKEDCHEST or
           variant == PickupVariant.PICKUP_ETERNALCHEST or
           variant == PickupVariant.PICKUP_OLDCHEST or
           variant == PickupVariant.PICKUP_WOODENCHEST or
           variant == PickupVariant.PICKUP_MEGACHEST or
           variant == PickupVariant.PICKUP_SPIKEDCHEST or
           variant == PickupVariant.PICKUP_REDCHEST then

            local rng = RNG()
            rng:SetSeed(entity.InitSeed, 0)
            if rng:RandomInt(100) < 50 then
                -- 50% chance to become a mimic
                entity:Morph(entity.Type, PickupVariant.PICKUP_MIMIC, 0, true, true)
                entity:GetSprite().Color = Color(1, 0.2, 0.2, 1, 0, 0, 0) -- Red tint
                Isaac.DebugString("SURPRISE! Chest was a mimic!")
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onEntitySpawn)
Isaac.DebugString("MimicChestChaos loaded!")
