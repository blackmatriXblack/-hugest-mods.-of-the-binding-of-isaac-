-- =============================================================================
--  PostNPCRenderGlow — The Binding of Isaac: Repentance
--  MC_POST_NPC_RENDER: Enemies below 30% HP glow red.
--  Uses entity:SetColor in render callback.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PostNPCRenderGlow", 1)

local COLOR_RED_GLOW = Color(1.0, 0.2, 0.2, 1.0, 0.0, 0.0, 0.0)

function mod:onPostNPCRender(npc, renderOffset)
    if not npc:Exists() or npc:IsDead() then return end

    local curHP = npc.HitPoints
    local maxHP = npc.MaxHitPoints
    if maxHP <= 0 then return end

    local hpPercent = curHP / maxHP
    if hpPercent <= 0.3 then
        -- Pulse intensity based on how low HP is
        local intensity = 1.0 - (hpPercent / 0.3)
        local r = 1.0
        local g = 1.0 - intensity * 0.8
        local b = 1.0 - intensity * 0.8
        local pulseColor = Color(r, g, b, 1.0, 0, 0, 0)
        npc:SetColor(pulseColor, -1, 1)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.onPostNPCRender)

Isaac.DebugString("PostNPCRenderGlow loaded!")
