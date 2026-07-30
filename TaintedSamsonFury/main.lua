-- =============================================================================
--  TaintedSamsonFury - The Binding of Isaac: Repentance
--  Tainted Samson: Berserk rage lasts 2 extra seconds.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedSamsonFury", 1)
local TAINTED_SAMSON = 27

function mod:onBerserk(player, rageTime)
    if player:GetPlayerType() == TAINTED_SAMSON then
        return rageTime + 60 -- add 2 extra seconds (60 frames at 30fps)
    end
    return rageTime
end

mod:AddCallback(ModCallbacks.MC_PRE_BERSERK, mod.onBerserk)
Isaac.DebugString("TaintedSamsonFury loaded!")
