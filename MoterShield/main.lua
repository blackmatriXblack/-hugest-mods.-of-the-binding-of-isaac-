-- =============================================================================
--  MoterShield — The Binding of Isaac: Repentance
--  Moters (Type=11, Variant=1) gain temporary invincibility every 5s for 2s.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MoterShield", 1)
local moterTimers = {}

function mod:onNPCUpdate(npc)
    if npc.Type ~= 11 or npc.Variant ~= 1 then return end

    local idx = GetPtrHash(npc)
    moterTimers[idx] = (moterTimers[idx] or 0) + 1

    if moterTimers[idx] >= 150 then
        moterTimers[idx] = 0
        npc:AddEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK)
        npc:SetColor(Color(0.5, 0.5, 1, 1, 0, 0, 0), 60, 0, false, false)
    end

    if moterTimers[idx] >= 60 and moterTimers[idx] < 60 + 60 then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
Isaac.DebugString("MoterShield loaded!")
