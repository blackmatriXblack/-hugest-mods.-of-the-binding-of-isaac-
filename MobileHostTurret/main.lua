-- =============================================================================
--  MobileHostTurret — The Binding of Isaac: Repentance
--  Mobile Hosts (Type=15, Variant=2) rotate continuously firing bullets.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MobileHostTurret", 1)

local FIRE_INTERVAL = 8  -- Frames between shots
local timers = {}

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= 15 or npc.Variant ~= 2 then return end

    local idx = npc.Index
    if not timers[idx] then
        timers[idx] = { fireTimer = 0, angle = 0 }
    end

    local t = timers[idx]
    t.fireTimer = t.fireTimer + 1
    t.angle = (t.angle + 4) % 360  -- Rotate continuously

    if t.fireTimer >= FIRE_INTERVAL then
        t.fireTimer = 0
        local rad = math.rad(t.angle)
        local dir = Vector(math.cos(rad), math.sin(rad))
        local tear = Isaac.Spawn(
            EntityType.ENTITY_PROJECTILE, 0, 0,
            npc.Position, dir * 5, npc
        )
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("MobileHostTurret loaded!")
