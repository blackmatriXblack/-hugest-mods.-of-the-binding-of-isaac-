-- Track pickup creation count this floor, display on HUD
local mod = RegisterMod("PickupInitTracker", 1)
local game = Game()
local pickupCount = 0

function mod:onPickupInit(pickup)
    if pickup then
        pickupCount = pickupCount + 1
    end
end

function mod:onNewLevel()
    pickupCount = 0
end

function mod:onPostRender()
    Isaac.RenderText("Pickups created this floor: " .. pickupCount, 60, 200, 1, 1, 1, 1)
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.onPickupInit)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("PickupInitTracker loaded! Tracks pickups created each floor.")
