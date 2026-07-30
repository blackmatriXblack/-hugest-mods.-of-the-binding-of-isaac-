-- Log what pickup was collected on collision
local mod = RegisterMod("PickupCollisionAlert", 1)
local game = Game()

function mod:onPickupCollision(pickup, collider, low)
    if pickup then
        local pickupType = pickup.Type
        local pickupVariant = pickup.Variant
        local pickupSubType = pickup.SubType
        Isaac.DebugString("Pickup collected! Type: " .. pickupType .. " Variant: " .. pickupVariant .. " SubType: " .. pickupSubType)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.onPickupCollision)
Isaac.DebugString("PickupCollisionAlert loaded! Logs collected pickups on collision.")
