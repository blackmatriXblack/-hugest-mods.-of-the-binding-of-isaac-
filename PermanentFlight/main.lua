-- =============================================================================
--  PERMANENT FLIGHT — The Binding of Isaac: Repentance
--  You have flight at all times. Cross any gap with ease.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PermanentFlight", 1)

function mod:onUpdate()
    local player = Isaac.GetPlayer(0)
    if player == nil then return end
    -- Flight = canFly flag set to true
    if not player:CanFly() then
        player.CanFly = true
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("Permanent Flight loaded! You can fly forever.")
