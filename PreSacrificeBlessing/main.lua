-- =============================================================================
--  PreSacrificeBlessing — The Binding of Isaac: Repentance
--  MC_PRE_SACRIFICE: 25% chance sacrifice room spikes don't consume health.
--  Return false to cancel.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PreSacrificeBlessing", 1)

function mod:onPreSacrifice(player, numSacrifices)
    if not player:Exists() then return end

    -- 25% chance to block sacrifice damage
    if math.random(1, 100) <= 25 then
        return false -- Cancel health cost; sacrifice still counts
    end
    return nil -- Default behavior (consume health)
end
mod:AddCallback(ModCallbacks.MC_PRE_SACRIFICE, mod.onPreSacrifice)

Isaac.DebugString("PreSacrificeBlessing loaded!")
