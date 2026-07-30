-- =============================================================================
--  BlightedOvumOrbit — The Binding of Isaac: Repentance
--  Blighted Ovum (Type=29.0) has orbiting protective tears
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BlightedOvumOrbit", 1)

local BLIGHTED_OVUM_TYPE = EntityType.ENTITY_BLIGHTED_OVUM -- Type 29 variant 0
local BLIGHTED_OVUM_VARIANT = 0
local ORBITAL_COUNT = 5
local ORBIT_RADIUS = 60
local ORBIT_SPEED = 0.03

local orbitalAngle = {}

function mod:onNPCUpdate(npc)
    if npc.Type ~= BLIGHTED_OVUM_TYPE or npc.Variant ~= BLIGHTED_OVUM_VARIANT then
        return
    end

    local idx = GetPtrHash(npc)
    if not orbitalAngle[idx] then
        orbitalAngle[idx] = 0
    end

    orbitalAngle[idx] = orbitalAngle[idx] + ORBIT_SPEED
    if orbitalAngle[idx] >= math.pi * 2 then
        orbitalAngle[idx] = orbitalAngle[idx] - math.pi * 2
    end

    -- Spawn/update orbital tears
    for i = 1, ORBITAL_COUNT do
        local angle = orbitalAngle[idx] + (i - 1) * (math.pi * 2 / ORBITAL_COUNT)
        local tearX = npc.Position.X + math.cos(angle) * ORBIT_RADIUS
        local tearY = npc.Position.Y + math.sin(angle) * ORBIT_RADIUS

        -- Spawn a stationary tear-like effect at orbit position
        local tear = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FART, 0,
            Vector(tearX, tearY), Vector.Zero, npc)
        if tear then
            tear.Timeout = 2
        end
    end

    -- Also fire homing tears periodically for attack
    -- Orbiting tears are visual protection; handle damage in ENTITY_TAKE_DMG
end

function mod:onNPCDeath(npc)
    local idx = GetPtrHash(npc)
    orbitalAngle[idx] = nil
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.onNPCDeath)
Isaac.DebugString("BlightedOvumOrbit loaded!")
