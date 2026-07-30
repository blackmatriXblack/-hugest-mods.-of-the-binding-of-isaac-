-- =============================================================================
--  NerveEndingSpawn - The Binding of Isaac: Repentance
--  Nerve Endings (from Womb) spawn 2 smaller nerve endings every 8 seconds
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("NerveEndingSpawn", 1)
local NERVE_TYPE = 233        -- EntityType.ENTITY_NERVE_ENDING
local SPAWN_INTERVAL = 240    -- 8 seconds at 30fps

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= NERVE_TYPE then return end
    if npc:IsDead() then return end

    local data = npc:GetData()
    local frame = Game():GetFrameCount()

    -- Initialize
    if data.init == nil then
        data.init = true
        data.lastSpawn = frame + math.random(60, 180)  -- Stagger first spawn
        npc:AddEntityFlags(EntityFlag.FLAG_RED)
    end

    -- Spawn 2 smaller nerve endings on cooldown
    if frame - data.lastSpawn >= SPAWN_INTERVAL then
        data.lastSpawn = frame

        for i = 1, 2 do
            local angle = math.random() * math.pi * 2
            local offset = Vector(math.cos(angle) * 50, math.sin(angle) * 50)
            local baby = Isaac.Spawn(NERVE_TYPE, 0, 0,
                npc.Position + offset, RandomVector():Resized(1.5), npc)
            if baby then
                baby.Scale = 0.6
                baby.MaxHitPoints = npc.MaxHitPoints * 0.4
                baby.HitPoints = baby.MaxHitPoints
                baby:AddEntityFlags(EntityFlag.FLAG_APPEAR)
            end
        end

        -- Visual feedback: mother nerve ending pulses
        local pulse = Isaac.Spawn(EntityType.ENTITY_EFFECT,
            EffectVariant.SHOCKWAVE, 0,
            npc.Position, Vector.Zero, npc)
        if pulse then
            pulse.SpriteScale = Vector(0.6, 0.6)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("NerveEndingSpawn loaded!")
