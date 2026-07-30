-- ==========================================================================
--  EnemyHighlight - The Binding of Isaac: Repentance
--  Low HP enemies glow red, nearing-death enemies pulse ominously!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("EnemyHighlight", 1)

mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, function(_, npc, renderOffset)
    if not npc:IsVulnerableEnemy() or npc.HitPoints <= 0 then return end

    local maxHP = npc.MaxHitPoints
    local curHP = npc.HitPoints
    local ratio = curHP / maxHP

    if ratio < 0.5 then
        local pulse = 0.6 + math.sin(Game():GetFrameCount() * 0.3) * 0.4
        local r = 1.0
        local g = ratio * 2
        local b = ratio * 2
        local alpha = (0.5 - ratio) * 2

        npc:SetColor(Color(r, g, b, 1, 0, 0, 0), 1, 0, false, true)

        if ratio < 0.15 then
            npc:SetColor(Color(1, 0, 0, 1, 0, 0, 0), 1, 0, false, true)
            if Game():GetFrameCount() % 20 < 10 then
                npc:SetColor(Color(1, 0, 0, 2, 0, 0, 0), 1, 0, false, true)
            end
        end
    end
end)

Isaac.DebugString("EnemyHighlight loaded! Red means dead!")
