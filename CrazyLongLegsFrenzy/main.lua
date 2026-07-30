-- =============================================================================
--  CrazyLongLegsFrenzy — The Binding of Isaac: Repentance
--  Crazy Long Legs (Type=207) speed triples when below 20% HP.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CrazyLongLegsFrenzy", 1)
local frenzyActive = {}

function mod:onNPCUpdate(npc)
    if npc.Type ~= 207 then return end

    local idx = GetPtrHash(npc)
    local hpPercent = npc.HitPoints / npc.MaxHitPoints

    if hpPercent <= 0.2 then
        if not frenzyActive[idx] then
            frenzyActive[idx] = true
            npc:SetColor(Color(1, 0.2, 0.2, 1, 0, 0, 0), 0, 0, true, false)
        end
        local pathfinder = npc.Pathfinder
        if pathfinder then
            pathfinder.MoveSpeed = 3.0
        end
    else
        frenzyActive[idx] = false
        local pathfinder = npc.Pathfinder
        if pathfinder and frenzyActive[idx] == false then
            pathfinder.MoveSpeed = 1.0
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
Isaac.DebugString("CrazyLongLegsFrenzy loaded!")
