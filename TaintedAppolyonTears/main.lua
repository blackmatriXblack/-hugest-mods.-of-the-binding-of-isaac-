-- =============================================================================
--  TaintedAppolyonTears - The Binding of Isaac: Repentance
--  Tainted Apollyon: Abyss absorbing a passive also gives +0.2 tears permanently.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedAppolyonTears", 1)
local TAINTED_APOLLYON = 34
local ABYSS = CollectibleType.COLLECTIBLE_ABYSS -- id 706
local TEARS_BONUS = 0.2

function mod:onUseItem(itemID, rng, player)
    if itemID ~= ABYSS then return end
    if player:GetPlayerType() ~= TAINTED_APOLLYON then return end

    -- Add permanent tears up
    player.MaxFireDelay = math.max(1, player.MaxFireDelay - 1)
    Isaac.DebugString("TaintedAppolyonTears: +0.2 tears permanently! Tears delay: " .. player.MaxFireDelay)
    return true
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem)
Isaac.DebugString("TaintedAppolyonTears loaded!")
