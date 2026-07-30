-- =============================================================================
--  TaintedLostPerfection - The Binding of Isaac: Repentance
--  Tainted Lost: Starts with Perfection trinket automatically.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedLostPerfection", 1)
local TAINTED_LOST = 31
local PERFECTION = TrinketType.TRINKET_PERFECTION -- id 138

function mod:onPlayerInit(player)
    if player:GetPlayerType() == TAINTED_LOST then
        if not player:HasTrinket(PERFECTION) then
            player:AddTrinket(PERFECTION, true)
            Isaac.DebugString("TaintedLostPerfection: Perfection trinket added!")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.onPlayerInit)
Isaac.DebugString("TaintedLostPerfection loaded!")
