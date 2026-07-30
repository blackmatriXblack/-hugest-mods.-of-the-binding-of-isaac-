-- =============================================================================
--  TaintedLazarusFlip - The Binding of Isaac: Repentance
--  Tainted Lazarus: Flip active gives a brief speed boost on use.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedLazarusFlip", 1)
local TAINTED_LAZARUS = 29
local FLIP_ITEM = CollectibleType.COLLECTIBLE_FLIP -- id 711
local SPEED_BOOST = 0.6
local BOOST_DURATION = 90 -- 3 seconds at 30fps

function mod:onUseItem(itemID, rng, player)
    if itemID ~= FLIP_ITEM then return end
    if player:GetPlayerType() ~= TAINTED_LAZARUS then return end

    player:AddSpeedModifier(SPEED_BOOST)
    Isaac.DebugString("TaintedLazarusFlip: Speed boost applied!")
    return true
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem)
Isaac.DebugString("TaintedLazarusFlip loaded!")
