-- =============================================================================
--  PillDoubleDip — The Binding of Isaac: Repentance
--  Each pill use has a 20% chance to trigger twice.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PillDoubleDip", 1)

function mod:onUsePill(pillEffect)
    if math.random() <= 0.2 then
        local player = Isaac.GetPlayer(0)
        if pillEffect ~= PillEffect.PILLEFFECT_BAD_GAS then
            -- Trigger the pill effect again
            player:UsePill(pillEffect, PillColor.PILL_NULL)
            Isaac.DebugString("PillDoubleDip: Extra pill use triggered!")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_PILL, mod.onUsePill)
Isaac.DebugString("PillDoubleDip loaded!")
