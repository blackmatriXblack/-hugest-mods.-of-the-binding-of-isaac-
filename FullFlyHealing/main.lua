-- =============================================================================
--  FullFlyHealing — The Binding of Isaac: Repentance
--  Full Flies (Type=53) regenerate 5% HP every 3 seconds.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FullFlyHealing", 1)
local healTimers = {}

function mod:onNPCUpdate(npc)
    if npc.Type ~= 53 then return end

    local idx = GetPtrHash(npc)
    healTimers[idx] = (healTimers[idx] or 0) + 1

    if healTimers[idx] >= 90 then
        healTimers[idx] = 0
        local maxHP = npc.MaxHitPoints
        local heal = maxHP * 0.05
        npc.HitPoints = math.min(npc.HitPoints + heal, maxHP)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
Isaac.DebugString("FullFlyHealing loaded!")
