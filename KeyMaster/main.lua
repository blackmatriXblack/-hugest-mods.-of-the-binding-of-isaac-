-- =============================================================================
--  KeyMaster — The Binding of Isaac: Repentance
--  Key pickups sometimes upgrade to golden keys (open any door).
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("KeyMaster", 1)

local GOLDEN_KEY_CHANCE = 0.15  -- 15% chance

function mod:UpgradeKeyPickup(pickup, variant, subtype)
    if variant == PickupVariant.PICKUP_KEY then
        if math.random() < GOLDEN_KEY_CHANCE then
            -- Morph to golden key (variant 21)
            pickup:Morph(EntityType.ENTITY_PICKUP, 21, 0, false, false, false)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.UpgradeKeyPickup)
Isaac.DebugString("KeyMaster loaded!")
