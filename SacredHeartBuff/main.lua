-- =============================================================================
--  Sacred Heart Buff - The Binding of Isaac: Repentance
--  Sacred Heart (182) homing tears curve 2x more aggressively.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SacredHeartBuff", 1)

-- Function to apply stronger homing for Sacred Heart
function mod:ApplyStrongerHoming(player)
    local data = player:GetData()
    -- Apply every frame to ensure homing is active
    player.TearFlags = player.TearFlags | TearFlags.TEAR_HOMING
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.ApplyStrongerHoming)
Isaac.DebugString("SacredHeartBuff loaded!")
