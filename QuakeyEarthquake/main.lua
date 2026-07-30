-- =============================================================================
--  QuakeyEarthquake - The Binding of Isaac: Repentance
--  Quakey causes screen shake and slows player when it jumps
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("QuakeyEarthquake", 1)
local QUAKEY_TYPE = 283 -- Quakey entity type (adjust if needed)
local JUMP_CHECK_INTERVAL = 5
local EARTHQUAKE_RADIUS = 200
local SLOW_DURATION = 60
local SHAKE_INTENSITY = 8

function mod:OnNPCUpdate(npc)
    if npc.Type ~= QUAKEY_TYPE then return end

    local player = Isaac.GetPlayer(0)

    local data = npc:GetData()

    -- Detect jumps: when Quakey's velocity Y drops (landing) or changes dramatically
    data.prevVelY = data.prevVelY or 0
    data.jumpCheckTimer = (data.jumpCheckTimer or 0) + 1

    if data.jumpCheckTimer >= JUMP_CHECK_INTERVAL then
        data.jumpCheckTimer = 0

        -- Detect landing impact: sudden velocity change
        local velChange = math.abs(npc.Velocity.Y - data.prevVelY)

        if velChange > 3.0 and npc.Velocity.Y > -2 then
            -- Quakey landed! Trigger earthquake

            -- Screen shake
            Game():ShakeScreen(SHAKE_INTENSITY)

            -- Slow all players in radius
            for p = 0, Game():GetNumPlayers() - 1 do
                local ply = Isaac.GetPlayer(p)
                if ply and ply.Position:Distance(npc.Position) <= EARTHQUAKE_RADIUS then
                    ply:AddSlowing(EntityRef(npc), SLOW_DURATION, 0.5, 0)
                    -- Small knockback from shockwave
                    local awayDir = (ply.Position - npc.Position):Normalized()
                    if awayDir:Length() > 0.01 then
                        ply.Velocity = awayDir * 3
                    end
                end
            end

            -- Spawn dust/rock particles at impact point
            for i = 1, 8 do
                local angle = math.random() * math.pi * 2
                local dist = math.random(10, 50)
                local particlePos = npc.Position + Vector(math.cos(angle) * dist, math.sin(angle) * dist)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0,
                    particlePos, Vector.Zero, npc)
            end

            -- Spawn small rocks/creep cracks at random positions in radius
            for i = 1, 3 do
                local angle = math.random() * math.pi * 2
                local dist = math.random(20, EARTHQUAKE_RADIUS * 0.7)
                local crackPos = npc.Position + Vector(math.cos(angle) * dist, math.sin(angle) * dist)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0,
                    crackPos, Vector(math.random() - 0.5, math.random() - 0.5) * 2, npc)
            end
        end

        data.prevVelY = npc.Velocity.Y
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("QuakeyEarthquake loaded!")
