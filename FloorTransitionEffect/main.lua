-- ==========================================================================
--  FloorTransitionEffect - The Binding of Isaac: Repentance
--  New floor entry plays a dramatic zoom-in effect!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("FloorTransitionEffect", 1)
local transitionTimer = 0
local TRANSITION_DURATION = 60
local currentFloor = nil

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    local level = Game():GetLevel()
    local stage = level:GetStage()
    local stageType = level:GetStageType()

    if currentFloor and currentFloor == stage then return end
    if not currentFloor then
        currentFloor = stage
        return
    end

    currentFloor = stage
    transitionTimer = TRANSITION_DURATION
    SFXManager():Play(SoundEffect.SOUND_HEARTBEAT_FAST, 1.0, 0, false, 1.0)

    local player = Isaac.GetPlayer(0)
    if player then
        for i = 1, 20 do
            local angle = math.random() * math.pi * 2
            local rad = math.random(30, 80)
            local px = player.Position.X + math.cos(angle) * rad
            local py = player.Position.Y + math.sin(angle) * rad
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0,
                Vector(px, py), Vector.Zero, player):SetTimeout(10)
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if transitionTimer <= 0 then return end
    transitionTimer = transitionTimer - 1

    local progress = transitionTimer / TRANSITION_DURATION
    local w, h = Isaac.GetScreenWidth(), Isaac.GetScreenHeight()

    local r, g, b = 0, 0, 0
    if math.random() < 0.3 then
        r, g, b = math.random() * progress, math.random() * progress, math.random() * progress
    end
end)

Isaac.DebugString("FloorTransitionEffect loaded! Entering new depths...")
