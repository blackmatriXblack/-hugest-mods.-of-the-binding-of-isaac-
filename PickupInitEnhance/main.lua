-- =============================================================================
--  PickupInitEnhance — The Binding of Isaac: Repentance
--  All spawned pickups get a sparkle visual effect with bright tint.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PickupInitEnhance", 1)

function mod:onPickupInit(pickup)
    if pickup and pickup.SetColor then
        -- Bright tint with slight variation
        local r = 1.0 + math.random() * 0.3
        local g = 1.0 + math.random() * 0.3
        local b = 1.0 + math.random() * 0.3
        pickup:SetColor(Color(r, g, b, 1, 0, 0, 0), 999999, 0)
        -- Spawn sparkle effect at pickup position
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPARKLE, 0, pickup.Position, Vector.Zero, nil)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.onPickupInit)
Isaac.DebugString("PickupInitEnhance loaded!")
