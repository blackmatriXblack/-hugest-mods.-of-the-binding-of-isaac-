-- =============================================================================
--  FleshMaidenCult - The Binding of Isaac: Repentance
--  Flesh Maiden spawns 2 Pooters to orbit and shield it
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FleshMaidenCult", 1)
local FLESH_MAIDEN_TYPE = 243
local POOTER_TYPE = 14 -- EntityType.ENTITY_POOTER
local ORBIT_RADIUS = 70
local ORBIT_SPEED = 0.04
local MAX_POOTERS = 2

function mod:OnEntitySpawn(entity)
    if entity.Type ~= FLESH_MAIDEN_TYPE then return end

    local npc = entity:ToNPC()
    if not npc then return end

    local data = npc:GetData()
    if data.pootersSpawned then return end
    data.pootersSpawned = true
    data.pooterRefs = {}
    data.orbitAngle = 0

    -- Spawn 2 orbiting Pooters
    for i = 1, MAX_POOTERS do
        local angle = (i - 1) * math.pi
        local offX = math.cos(angle) * ORBIT_RADIUS
        local offY = math.sin(angle) * ORBIT_RADIUS
        local spawnPos = npc.Position + Vector(offX, offY)
        local pooter = Isaac.Spawn(EntityType.ENTITY_POOTER, 0, 0, spawnPos, Vector.Zero, npc)
        if pooter then
            pooter:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK | EntityFlag.FLAG_NO_TARGET)
            table.insert(data.pooterRefs, pooter)
        end
    end
end

function mod:OnNPCUpdate(npc)
    if npc.Type ~= FLESH_MAIDEN_TYPE then return end

    local data = npc:GetData()
    if not data.pooterRefs then return end

    data.orbitAngle = (data.orbitAngle or 0) + ORBIT_SPEED

    -- Update positions of orbiting Pooters
    for i, pooter in ipairs(data.pooterRefs) do
        if pooter:Exists() and pooter.HitPoints > 0 then
            local angle = data.orbitAngle + (i - 1) * math.pi
            local targetX = npc.Position.X + math.cos(angle) * ORBIT_RADIUS
            local targetY = npc.Position.Y + math.sin(angle) * ORBIT_RADIUS
            pooter.Velocity = Vector(targetX - pooter.Position.X, targetY - pooter.Position.Y) * 0.3
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.OnEntitySpawn)
mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("FleshMaidenCult loaded!")
