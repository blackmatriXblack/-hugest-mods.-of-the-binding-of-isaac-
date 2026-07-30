-- =============================================================================
--  PickupUpdateFloater — The Binding of Isaac: Repentance
--  MC_POST_PICKUP_UPDATE: Pickups bob up and down with a sine wave animation.
--  Modify Position offset.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PickupUpdateFloater", 1)

local BASE_Y = {}       -- Base Y position per pickup
local BOUNCE_AMPLITUDE = 3
local BOUNCE_SPEED = 0.05

function mod:onPickupInit(pickup)
    local idx = GetPtrHash(pickup)
    BASE_Y[idx] = pickup.Position.Y
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.onPickupInit)

function mod:onPostPickupUpdate(pickup)
    if not pickup:Exists() or pickup:IsDead() then return end

    local idx = GetPtrHash(pickup)
    local baseY = BASE_Y[idx]
    if not baseY then
        baseY = pickup.Position.Y
        BASE_Y[idx] = baseY
    end

    local offset = math.sin(Isaac.GetFrameCount() * BOUNCE_SPEED) * BOUNCE_AMPLITUDE
    pickup.Position = Vector(pickup.Position.X, baseY + offset)
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, mod.onPostPickupUpdate)

Isaac.DebugString("PickupUpdateFloater loaded!")
