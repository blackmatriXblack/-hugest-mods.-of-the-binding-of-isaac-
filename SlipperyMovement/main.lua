-- ==========================================================================
--  SlipperyMovement - The Binding of Isaac: Repentance
--  Player slides with momentum — ice physics for Isaac!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SlipperyMovement", 1)
local momentum = Vector.Zero
local FRICTION = 0.95
local ACCEL = 0.3

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    local input = Vector.Zero
    if Input.IsActionPressed(ButtonAction.ACTION_LEFT, player.ControllerIndex) then
        input.X = -1
    end
    if Input.IsActionPressed(ButtonAction.ACTION_RIGHT, player.ControllerIndex) then
        input.X = 1
    end
    if Input.IsActionPressed(ButtonAction.ACTION_UP, player.ControllerIndex) then
        input.Y = -1
    end
    if Input.IsActionPressed(ButtonAction.ACTION_DOWN, player.ControllerIndex) then
        input.Y = 1
    end

    if input:Length() > 0 then
        input = input:Normalized()
        momentum = momentum + input * ACCEL
    end

    momentum = momentum * FRICTION
    local maxSpeed = player.MoveSpeed * 1.5
    if momentum:Length() > maxSpeed then
        momentum = momentum:Normalized() * maxSpeed
    end

    player:AddVelocity(momentum)

    if momentum:Length() > 0.05 then
        local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0,
            player.Position, Vector.Zero, player)
        if trail then trail:SetTimeout(5) end
    end
end)

Isaac.DebugString("SlipperyMovement loaded! Ice ice baby!")
