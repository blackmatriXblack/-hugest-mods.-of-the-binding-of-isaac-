-- =============================================================================
--  PreNPCUpdateWarn - The Binding of Isaac: Repentance
--  Slows and flashes red NPCs about to hit the player as a warning.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PreNPCUpdateWarn", 1)

function mod:onPreNPCUpdate(npc)
    if npc:IsDead() or npc:GetSprite():IsPlaying("Death") then return end
    local player = Isaac.GetPlayer(0)
    if player:IsDead() then return end

    local dist = npc.Position:Distance(player.Position)
    local warnDist = 120

    if dist < warnDist then
        local vel = npc.Velocity
        -- Slow NPC by 50% as warning
        npc.Velocity = vel * 0.5
        -- Flash red tint
        npc:SetColor(Color(1, 0.3, 0.3, 1, 0, 0, 0), 2, 1, false, false)
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.onPreNPCUpdate)
Isaac.DebugString("PreNPCUpdateWarn loaded!")
