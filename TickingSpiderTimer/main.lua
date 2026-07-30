-- =============================================================================
--  TickingSpiderTimer — The Binding of Isaac: Repentance
--  Ticking Spiders (Type=250) have visible countdown above before exploding.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TickingSpiderTimer", 1)
local spiderTimers = {}

function mod:onNPCUpdate(npc)
    if npc.Type ~= 250 then return end

    local idx = GetPtrHash(npc)
    spiderTimers[idx] = (spiderTimers[idx] or 0) + 1
end

function mod:onNPCRender(npc, offset)
    if npc.Type ~= 250 then return end

    local idx = GetPtrHash(npc)
    local timer = spiderTimers[idx] or 0
    local remaining = math.max(0, math.ceil((180 - timer) / 30))

    local text = tostring(remaining)
    local color = KColor(1, 1 - (remaining / 6), 0, 1)
    local pos = Isaac.WorldToScreen(npc.Position) + Vector(0, -40) + offset

    Isaac.RenderText(text, pos.X, pos.Y, color, 1, 0)
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, mod.onNPCRender)
Isaac.DebugString("TickingSpiderTimer loaded!")
