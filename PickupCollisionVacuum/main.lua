-- =============================================================================
--  PickupCollisionVacuum — The Binding of Isaac: Repentance
--  Pickups within 150 range get pulled toward player (magnetic).
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PickupCollisionVacuum", 1)

function mod:onPrePickupCollision(pickup, collider, low)
    if collider and collider:IsPlayer() then
        local dist = pickup.Position:Distance(collider.Position)
        if dist <= 150 and dist > 0 then
            -- Pull pickup toward player
            local dir = (collider.Position - pickup.Position):Normalized()
            pickup.Velocity = dir * (150 - dist) * 0.05
        end
    end
    return nil -- let normal handling proceed
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.onPrePickupCollision)
Isaac.DebugString("PickupCollisionVacuum loaded!")
