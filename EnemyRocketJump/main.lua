-- ==========================================================================
--  EnemyRocketJump - The Binding of Isaac: Repentance
--  Enemies occasionally rocket-jump across the room for hilarious chaos!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("EnemyRocketJump", 1)
local JUMP_TIMERS = {}
local JUMP_COOLDOWN = 120
local JUMP_CHANCE = 0.002

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc:IsBoss() or npc:IsDead() or not npc:IsActiveEnemy() then return end

    local idx = npc.Index
    if not JUMP_TIMERS[idx] then
        JUMP_TIMERS[idx] = {cooldown = 0, jumping = false, jumpVel = nil, jumpFrames = 0}
    end

    local jt = JUMP_TIMERS[idx]

    if jt.jumping then
        jt.jumpFrames = jt.jumpFrames + 1
        if jt.jumpFrames > 15 then
            jt.jumping = false
            jt.cooldown = JUMP_COOLDOWN
            jt.jumpFrames = 0
        end
        return
    end

    if jt.cooldown > 0 then
        jt.cooldown = jt.cooldown - 1
        return
    end

    if math.random() < JUMP_CHANCE then
        local player = Isaac.GetPlayer(0)
        local dir = (player.Position - npc.Position):Normalized()
        local jumpPower = 15 + math.random(0, 5)
        npc.Velocity = dir * jumpPower + Vector(0, -8)
        jt.jumping = true
        jt.jumpFrames = 0
        SFXManager():Play(SoundEffect.SOUND_MOMS_HEART_DEATH, 0.4, 0, false, 2.0)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0,
            npc.Position, Vector(math.random(-3,3), -5), npc)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    JUMP_TIMERS = {}
end)

Isaac.DebugString("EnemyRocketJump loaded! Enemies go WHEEE!")
