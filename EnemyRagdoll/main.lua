-- ==========================================================================
--  EnemyRagdoll - The Binding of Isaac: Repentance
--  Enemies fling dramatically on death with ragdoll physics!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("EnemyRagdoll", 1)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if npc:IsBoss() then
        for i = 1, 8 do
            local angle = math.random() * math.pi * 2
            local speed = math.random(5, 15)
            local vel = Vector(math.cos(angle) * speed, math.sin(angle) * speed - 8)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0,
                npc.Position, vel, npc):SetTimeout(20 + math.random(0, 10))
        end
        return
    end

    local player = Isaac.GetPlayer(0)
    local angle = math.random() * math.pi * 0.5 - math.pi * 0.25
    local power = 6 + math.random(4, 12)
    local dir = (npc.Position - player.Position):Normalized()
    if dir:Length() < 0.1 then dir = Vector(math.random() * 2 - 1, -1) end
    dir = dir:Normalized()

    npc.Velocity = dir * power + Vector(0, -6 - math.random(0, 4))

    local spinVel = math.random(-15, 15)
    local spr = npc:GetSprite()
    if spr then
        spr.Rotation = math.random() * 360
        spr.PlaybackSpeed = 0
    end

    for i = 1, 4 do
        local vel = dir * math.random(2, 6) + Vector(math.random(-3, 3), math.random(-5, -2))
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0,
            npc.Position, vel, npc):SetTimeout(10)
    end

    SFXManager():Play(SoundEffect.SOUND_MONSTER_GRUNT_5, 0.5, 0, false, 0.7 + math.random() * 0.6)
end)

Isaac.DebugString("EnemyRagdoll loaded! YEET!")
