-- =============================================================================
--  GlobinRegenerator — The Binding of Isaac: Repentance
--  Globins (Type=11) regenerate 3x faster.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GlobinRegenerator", 1)

local REGEN_SPEED = 3

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= 11 then return end

    -- Globins in pile state have a regen timer; accelerate it
    -- State 1 or 2 typically represents the gluing/regen phase
    if npc.State == 1 or npc.State == 2 then
        if npc.StateFrame > 0 and npc.StateFrame < 999 then
            npc.StateFrame = math.max(1, npc.StateFrame - (REGEN_SPEED - 1))
        end
    end

    -- Also boost the initial glue-down delay
    if npc.State == 3 and npc.StateFrame > 0 and npc.StateFrame < 999 then
        npc.StateFrame = math.max(1, npc.StateFrame - (REGEN_SPEED - 1))
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("GlobinRegenerator loaded!")
