local mod = RegisterMod("PickupPreCollision", 1)

function mod:onPrePickupCollision(pickup, player, low)
    Isaac.DebugString("About to pick up: " .. tostring(pickup.Variant))
    return nil
end

mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.onPrePickupCollision)
