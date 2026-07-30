-- ==========================================================================
--  BossDeathExplosion - The Binding of Isaac: Repentance
--  Bosses have a dramatic multi-stage death explosion — go out with a bang!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("BossDeathExplosion", 1)
local pendingExplosions = {}
local explosionTimers = {}

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if not npc:IsBoss() then return end

    local pos = npc.Position
    table.insert(pendingExplosions, {
        pos = pos,
        stage = 0,
        timer = 0,
        maxStages = 4
    })

    SFXManager():Play(SoundEffect.SOUND_SUMMON_POOF, 0.8, 0, false, 0.4)
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local toRemove = {}
    for idx, exp in ipairs(pendingExplosions) do
        exp.timer = exp.timer + 1

        if exp.stage == 0 and exp.timer > 15 then
            exp.stage = 1
            exp.timer = 0
            Game():ScreenShake(3, 10)
            SFXManager():Play(SoundEffect.SOUND_MEGA_BLAST, 0.7, 0, false, 0.8)
            for i = 1, 12 do
                local angle = i * math.pi / 6
                local spawnPos = exp.pos + Vector(math.cos(angle) * 40, math.sin(angle) * 40)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RED_CANDLE_FLAME, 0,
                    spawnPos, Vector(math.cos(angle) * 3, math.sin(angle) * 3), nil):SetTimeout(15)
            end
        elseif exp.stage == 1 and exp.timer > 15 then
            exp.stage = 2
            exp.timer = 0
            Game():BombExplosion(exp.pos)
            Game():ScreenShake(5, 15)
        elseif exp.stage == 2 and exp.timer > 10 then
            exp.stage = 3
            exp.timer = 0
            for i = 1, 20 do
                local angle = math.random() * math.pi * 2
                local speed = math.random(5, 12)
                local spark = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPARKLE, 0,
                    exp.pos, Vector(math.cos(angle) * speed, math.sin(angle) * speed - 4), nil)
                if spark then spark:SetTimeout(20) end
            end
            SFXManager():Play(SoundEffect.SOUND_BOSS2INTRO, 0.6, 0, false, 1.5)
        elseif exp.stage == 3 and exp.timer > 20 then
            table.insert(toRemove, idx)
            Game():BombExplosion(exp.pos:__add(Vector(30, 0)))
            Game():BombExplosion(exp.pos:__add(Vector(-30, 0)))
            Game():BombExplosion(exp.pos:__add(Vector(0, 30)))
            Game():BombExplosion(exp.pos:__add(Vector(0, -30)))
        end
    end

    for i = #toRemove, 1, -1 do
        table.remove(pendingExplosions, toRemove[i])
    end
end)

Isaac.DebugString("BossDeathExplosion loaded! KABOOM x4!")
