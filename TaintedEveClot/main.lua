-- =============================================================================
--  TaintedEveClot - The Binding of Isaac: Repentance
--  Tainted Eve: Clots regenerate 1 HP after 10 seconds if alive.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedEveClot", 1)
local TAINTED_EVE = 26
local CLOT_VARIANT = FamiliarVariant.CLOT
local clotTimers = {}
local REGEN_DELAY = 300 -- ~10 seconds at 30fps

function mod:onNPCUpdate(npc)
    if npc.Variant ~= CLOT_VARIANT then return end

    local idx = GetPtrHash(npc)
    clotTimers[idx] = (clotTimers[idx] or 0) + 1

    if clotTimers[idx] >= REGEN_DELAY and npc.HitPoints > 0 and npc.HitPoints < npc.MaxHitPoints then
        npc:AddHealth(2) -- 1 HP = 2 in game units
        clotTimers[idx] = 0
        Isaac.DebugString("TaintedEveClot: Clot regenerated 1 HP.")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
Isaac.DebugString("TaintedEveClot loaded!")
