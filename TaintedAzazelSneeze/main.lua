-- =============================================================================
--  TaintedAzazelSneeze - The Binding of Isaac: Repentance
--  Tainted Azazel: Sneeze attack is full brimstone width.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedAzazelSneeze", 1)
local TAINTED_AZAZEL = 28

function mod:onPEffectUpdate(player)
    if player:GetPlayerType() ~= TAINTED_AZAZEL then return end
    -- Sneeze is the Brimstone-like attack of Tainted Azazel
    -- We modify its width via tear flags
    player.TearFlags = player.TearFlags | TearFlags.TEAR_BRIMSTONE_FULL
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
Isaac.DebugString("TaintedAzazelSneeze loaded!")
