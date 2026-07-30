-- =============================================================================
--  GurglingAcid — The Binding of Isaac: Repentance
--  Gurglings (Type=34) leave creep trail behind them.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GurglingAcid", 1)
local creepTimers = {}

function mod:onNPCUpdate(npc)
    if npc.Type ~= 34 then return end

    local idx = GetPtrHash(npc)
    creepTimers[idx] = (creepTimers[idx] or 0) + 1

    if creepTimers[idx] >= 10 then
        creepTimers[idx] = 0
        local pos = npc.Position
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, pos, Vector.Zero, npc)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
Isaac.DebugString("GurglingAcid loaded!")
