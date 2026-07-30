-- =============================================================================
--  PsychicHorrorFloat - The Binding of Isaac: Repentance
--  Psychic Horrors float and use telekinesis to slowly pull the player
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PsychicHorrorFloat", 1)
local PSYCHIC_HORROR_TYPE = 262
local PULL_STRENGTH = 0.15
local PULL_RADIUS = 350
local FLOAT_AMPLITUDE = 8

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= PSYCHIC_HORROR_TYPE then return end
    if npc:IsDead() then return end

    local data = npc:GetData()
    local player = Isaac.GetPlayer(0)

    if data.init == nil then
        data.init = true
        data.baseY = npc.Position.Y
        data.phase = math.random() * math.pi * 2
        npc:AddEntityFlags(EntityFlag.FLAG_FEAR)
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
    end

    -- Floating animation: gentle bobbing up and down
    data.phase = data.phase + 0.03
    npc.Position = Vector(npc.Position.X, data.baseY + math.sin(data.phase) * FLOAT_AMPLITUDE)

    -- Psychic pull: slowly drag the player toward the horror
    if player:Exists() then
        local diff = npc.Position - player.Position
        local dist = diff:Length()

        if dist <= PULL_RADIUS and dist > 30 then
            local pullForce = PULL_STRENGTH * (1.0 - (dist / PULL_RADIUS))
            local dir = diff:Normalized()
            player.Velocity = player.Velocity + dir * pullForce

            -- Visual: psychic distortion waves
            if Game():GetFrameCount() % 8 == 0 then
                local wave = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0,
                    npc.Position, Vector.Zero, npc)
                if wave then
                    wave.SpriteScale = Vector(0.4, 0.4)
                end
            end
        end

        -- If player gets too close, push back violently (self-defense)
        if dist <= 40 then
            local pushDir = (player.Position - npc.Position):Normalized()
            player.Velocity = player.Velocity + pushDir * 5
            player:TakeDamage(1, DamageFlag.DAMAGE_NOKILL, EntityRef(npc), 0)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("PsychicHorrorFloat loaded!")
