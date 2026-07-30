-- =============================================================================
--  KamikazeLeech - The Binding of Isaac: Repentance
--  Kamikaze Leeches explode with 50% more damage and leave burning fire
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("KamikazeLeech", 1)
local LEECH_TYPE = 47          -- EntityType.ENTITY_LEECH
local EXPLOSION_DAMAGE = 75    -- 50% more than normal

function mod:onNpcDeath(_, npc)
    if npc.Type ~= LEECH_TYPE then return end

    local pos = npc.Position
    local room = Game():GetRoom()

    -- Big fiery explosion
    local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT,
        EffectVariant.BOMB_EXPLOSION, 0,
        pos, Vector.Zero, npc)
    if explosion then
        explosion.SpriteScale = Vector(1.5, 1.5)
        explosion.DepthOffset = -50
    end

    -- Secondary fire burst effect
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE_WAVE, 0,
        pos, Vector.Zero, npc)

    -- Damage enemies in blast radius
    local ents = Isaac.GetRoomEntities()
    for _, ent in ipairs(ents) do
        if ent:IsVulnerableEnemy() and ent.Type ~= LEECH_TYPE then
            local dist = (ent.Position - pos):Length()
            if dist <= 120 then
                -- Damage falls off with distance
                local dmgScale = 1.0 - (dist / 120) * 0.5
                ent:TakeDamage(EXPLOSION_DAMAGE * dmgScale,
                    DamageFlag.DAMAGE_EXPLOSION + DamageFlag.DAMAGE_FIRE,
                    EntityRef(npc), 0)
            end
        end
    end

    -- Damage player if close
    local player = Isaac.GetPlayer(0)
    if player:Exists() then
        local dist = (player.Position - pos):Length()
        if dist <= 120 then
            player:TakeDamage(1, DamageFlag.DAMAGE_EXPLOSION,
                EntityRef(npc), 0)
        end
    end

    -- Leave 3 fire grid entities in random positions around death spot
    for i = 1, 3 do
        local angle = (i / 3) * math.pi * 2 + math.random() * 0.5
        local firePos = pos + Vector(math.cos(angle) * 60, math.sin(angle) * 60)
        firePos = room:GetClampedPosition(firePos, 20)
        Isaac.Spawn(EntityType.ENTITY_EFFECT,
            EffectVariant.FIRE_PLACE, 0,
            firePos, Vector.Zero, npc)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.onNpcDeath)
Isaac.DebugString("KamikazeLeech loaded!")
