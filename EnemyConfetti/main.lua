-- ==========================================================================
--  EnemyConfetti - The Binding of Isaac: Repentance
--  Enemies explode into colorful confetti particles on death!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("EnemyConfetti", 1)

local COLORS = {
    Color(1, 0, 0, 1),
    Color(0, 1, 0, 1),
    Color(0, 0, 1, 1),
    Color(1, 1, 0, 1),
    Color(1, 0, 1, 1),
    Color(0, 1, 1, 1),
    Color(1, 0.5, 0, 1),
    Color(0.5, 0, 1, 1),
    Color(0, 1, 0.5, 1),
}

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    local pos = npc.Position
    local count = npc:IsBoss() and 40 or 15

    for i = 1, count do
        local angle = math.random() * math.pi * 2
        local speed = math.random(2, 8)
        local vel = Vector(math.cos(angle) * speed, math.sin(angle) * speed - 3)
        local particle = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPARKLE, 0,
            pos, vel, npc)
        if particle then
            particle:SetTimeout(15 + math.random(0, 15))
            if i % 2 == 0 then
                particle:SetColor(COLORS[math.random(#COLORS)], 0, 0)
            end
        end
    end

    if not npc:IsBoss() then
        SFXManager():Play(SoundEffect.SOUND_CHEST_DROP, 0.3, 0, false, 1.5 + math.random() * 0.5)
    else
        SFXManager():Play(SoundEffect.SOUND_FETUS_JUMP, 0.5, 0, false, 1.2)
    end
end)

Isaac.DebugString("EnemyConfetti loaded! Celebrating every kill!")
