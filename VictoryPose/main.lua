-- ==========================================================================
--  VictoryPose - The Binding of Isaac: Repentance
--  Player does a victory animation with brief invincibility when clearing a room!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("VictoryPose", 1)
local victoryTimer = 0
local VICTORY_DURATION = 45

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_CLEAR, function()
    victoryTimer = VICTORY_DURATION
    local player = Isaac.GetPlayer(0)
    if player then
        player:AddEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK)
        player:SetColor(Color(1, 0.8, 0, 1, 0, 0, 0), 0, 1)

        for i = 1, 15 do
            local angle = i * math.pi * 2 / 15
            local spark = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPARKLE, 0,
                player.Position + Vector(math.cos(angle) * 30, math.sin(angle) * 30),
                Vector(math.cos(angle) * 3, math.sin(angle) * 3 - 2), player)
            if spark then spark:SetTimeout(15) end
        end

        SFXManager():Play(SoundEffect.SOUND_CHALLENGE_COMPLETE, 0.8, 0, false, 1.0)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if victoryTimer <= 0 then return end
    victoryTimer = victoryTimer - 1

    local bounce = math.sin(victoryTimer * 0.4) * 2
    player.PositionOffset = Vector(0, bounce)

    if victoryTimer % 6 == 0 then
        local spark = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPARKLE, 0,
            player.Position + Vector(math.random(-15, 15), -25),
            Vector(0, -3), player)
        if spark then spark:SetTimeout(10) end
    end

    if victoryTimer == 0 then
        player:ClearEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK)
        player:SetColor(Color(1, 1, 1, 1, 0, 0, 0), 0, 1)
        player.PositionOffset = Vector.Zero
    end
end)

Isaac.DebugString("VictoryPose loaded! VICTORY!")
