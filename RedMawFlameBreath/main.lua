-- =============================================================================
--  RedMawFlameBreath — The Binding of Isaac: Repentance
--  Red Maws (Type=14, Variant=1) leave fire on the ground periodically.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RedMawFlameBreath", 1)

local FIRE_INTERVAL = 90  -- 3 seconds at 30 FPS
local fireTimers = {}

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= 14 or npc.Variant ~= 1 then return end

    local idx = npc.Index
    if not fireTimers[idx] then
        fireTimers[idx] = 0
    end

    fireTimers[idx] = fireTimers[idx] + 1

    if fireTimers[idx] >= FIRE_INTERVAL then
        fireTimers[idx] = 0
        -- Spawn fire grid entity on the floor at NPC position
        local fire = Isaac.Spawn(
            EntityType.ENTITY_EFFECT, 14, 0,
            npc.Position, Vector.Zero, npc
        )
        if fire then
            fire.DepthOffset = -10
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("RedMawFlameBreath loaded!")
