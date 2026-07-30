-- =============================================================================
--  BloatPeepLaser — The Binding of Isaac: Repentance
--  Bloat (Type=56.0) / Peep (Type=42.0) brimstone laser sweeps 360 degrees
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BloatPeepLaser", 1)

local BLOAT_TYPE = EntityType.ENTITY_BLOAT -- Type 56.0
local PEEP_TYPE = EntityType.ENTITY_PEEP -- Type 42.0
local SWEEP_SPEED = 0.04 -- Radians per frame
local LASER_INTERVAL = 120 -- Fire laser every 4 seconds
local laserAngle = {}
local laserTimer = {}

function mod:onNPCUpdate(npc)
    if npc.Type ~= BLOAT_TYPE and npc.Type ~= PEEP_TYPE then
        return
    end

    local idx = GetPtrHash(npc)

    if not laserTimer[idx] then
        laserTimer[idx] = 0
        laserAngle[idx] = 0
    end

    laserTimer[idx] = laserTimer[idx] + 1
    laserAngle[idx] = laserAngle[idx] + SWEEP_SPEED

    if laserAngle[idx] >= math.pi * 2 then
        laserAngle[idx] = laserAngle[idx] - math.pi * 2
    end

    -- Fire brimstone laser in current sweep direction
    if laserTimer[idx] >= LASER_INTERVAL then
        laserTimer[idx] = 0

        local dir = Vector(math.cos(laserAngle[idx]), math.sin(laserAngle[idx]))
        local laserVel = dir * 3

        local params = ProjectileParams()
        params.Variant = ProjectileVariant.PROJECTILE_BRIMSTONE
        npc:FireProjectiles(npc.Position, laserVel, 0, params)
    end
end

function mod:onNPCDeath(npc)
    local idx = GetPtrHash(npc)
    laserTimer[idx] = nil
    laserAngle[idx] = nil
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.onNPCDeath)
Isaac.DebugString("BloatPeepLaser loaded!")
