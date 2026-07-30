-- =============================================================================
--  SuicideFlyExplosion - The Binding of Isaac: Repentance
--  Suicide Flies detonate with a massive 2x explosion radius
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SuicideFlyExplosion", 1)
local SUICIDE_FLY_TYPE = 25    -- EntityType.ENTITY_BOOMFLY
local SUICIDE_VARIANT = 0      -- Default Boom Fly

function mod:onNpcDeath(_, npc)
    if npc.Type ~= SUICIDE_FLY_TYPE or npc.Variant ~= SUICIDE_VARIANT then
        return
    end

    local pos = npc.Position

    -- Spawn a massive explosion with 2x the normal radius
    local explosion = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0,
        pos, Vector.Zero, npc)
    if explosion then
        explosion.SpriteScale = Vector(2, 2)  -- Double the visual radius
        explosion.DepthOffset = -100
    end

    -- Apply damage to all enemies within 2x radius
    local ents = Isaac.GetRoomEntities()
    for _, ent in ipairs(ents) do
        if ent:IsVulnerableEnemy() and ent.Type ~= SUICIDE_FLY_TYPE then
            local dist = (ent.Position - pos):Length()
            if dist <= 160 then  -- 2x normal explosion radius
                ent:TakeDamage(50, DamageFlag.DAMAGE_EXPLOSION, EntityRef(npc), 0)
            end
        end
    end

    -- Also damage the player if close
    local player = Isaac.GetPlayer(0)
    if player:Exists() then
        local dist = (player.Position - pos):Length()
        if dist <= 160 then
            player:TakeDamage(1, DamageFlag.DAMAGE_EXPLOSION, EntityRef(npc), 0)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.onNpcDeath)
Isaac.DebugString("SuicideFlyExplosion loaded!")
