-- ==========================================================================
--  Health Decay - The Binding of Isaac: Repentance
--  Player loses 1 heart container every 3 minutes
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("HealthDecay", 1)
local game = Game()
local decayTimer = 0
local DECAY_DELAY = 5400 -- 3 minutes at 30fps

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    decayTimer = decayTimer + 1

    if decayTimer >= DECAY_DELAY then
        decayTimer = 0
        
        -- Remove one heart container
        local maxHearts = player:GetMaxHearts()
        if maxHearts > 1 then
            player:AddMaxHearts(-2, true)  -- Remove one full heart container
            
            -- Visual effect
            local pos = player.Position
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02,
                0, pos, Vector.Zero, nil)
            
            -- Red flash visual
            player:SetColor(Color(1, 0.3, 0.3, 1, 0, 0, 0), 30, 1, false, false)
            
            Isaac.DebugString(string.format("Heart container decayed! HP remaining: %d", maxHearts - 2))
        end
    end

    -- Warning visuals when decay is approaching
    if decayTimer > DECAY_DELAY - 300 then
        local flicker = math.sin(decayTimer * 0.3)
        if flicker > 0 then
            player:SetColor(Color(1, 0.5, 0.5, 1, 0, 0, 0), -1, 1, false, false)
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local minutesLeft = math.max(0, math.floor((DECAY_DELAY - decayTimer) / 30 / 60))
    local secondsLeft = math.floor(((DECAY_DELAY - decayTimer) / 30) % 60)
    if decayTimer > DECAY_DELAY - 300 then
        Isaac.RenderText(string.format("HP decay in %d:%02d!", minutesLeft, secondsLeft),
            250, 20, 0.8, 1, 0.3, 0.3)
    end
end)

Isaac.DebugString("Health Decay loaded!")
