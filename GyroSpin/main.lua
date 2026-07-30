-- =============================================================================
--  GyroSpin - The Binding of Isaac: Repentance
--  Gyro spins faster over time dealing scaling contact damage
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GyroSpin", 1)
local GYRO_TYPE = 286
local SPIN_ACCEL = 0.05 -- speed increase per frame
local MAX_SPIN_SPEED = 4.0
local BASE_CONTACT_DMG = 1.0
local DMG_PER_SPEED = 0.4

function mod:OnNPCUpdate(npc)
    if npc.Type ~= GYRO_TYPE then return end

    local data = npc:GetData()
    data.spinSpeed = (data.spinSpeed or 0.05) + SPIN_ACCEL

    -- Cap spin speed
    if data.spinSpeed > MAX_SPIN_SPEED then
        data.spinSpeed = MAX_SPIN_SPEED
    end

    -- Orbit/spin around its original spawn position
    data.spawnPos = data.spawnPos or npc.Position
    data.orbitAngle = (data.orbitAngle or 0) + data.spinSpeed * 0.02

    local radius = 0
    -- Gyro orbits in a widening circle as speed increases
    if data.spinSpeed > 0.5 then
        radius = (data.spinSpeed / MAX_SPIN_SPEED) * 80
    end

    if radius > 5 then
        local targetX = data.spawnPos.X + math.cos(data.orbitAngle) * radius
        local targetY = data.spawnPos.Y + math.sin(data.orbitAngle) * radius
        local toTarget = Vector(targetX - npc.Position.X, targetY - npc.Position.Y)
        npc.Velocity = toTarget * 0.3
    end

    -- Scale contact damage based on spin speed
    npc.CollisionDamage = BASE_CONTACT_DMG + (data.spinSpeed * DMG_PER_SPEED)

    -- Visual: spin color based on speed
    local intensity = data.spinSpeed / MAX_SPIN_SPEED
    npc.Color = Color(1, 1 - intensity * 0.5, 1 - intensity * 0.7, 1, 0, 0, 0)

    -- At max speed, leave trail effect
    if data.spinSpeed >= MAX_SPIN_SPEED * 0.8 then
        if (data.orbitAngle * 100) % 10 < 1 then
            local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE, 0,
                npc.Position, Vector.Zero, npc)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("GyroSpin loaded!")
