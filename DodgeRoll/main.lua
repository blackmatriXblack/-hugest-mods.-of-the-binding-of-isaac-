-- ==========================================================================
--  DodgeRoll - The Binding of Isaac: Repentance
--  Press a key to dodge-roll with brief invincibility frames!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("DodgeRoll", 1)
local isRolling = false
local rollTimer = 0
local ROLL_DURATION = 15
local ROLL_COOLDOWN = 30
local cooldownTimer = 0

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if cooldownTimer > 0 then
        cooldownTimer = cooldownTimer - 1
    end

    if isRolling then
        rollTimer = rollTimer + 1
        player:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
        if rollTimer >= ROLL_DURATION then
            isRolling = false
            rollTimer = 0
            player:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
            player.Velocity = Vector.Zero
        end
        return
    end

    local keyPressed = Input.IsActionPressed(ButtonAction.ACTION_DROP, player.ControllerIndex)
    if keyPressed and cooldownTimer <= 0 and not isRolling then
        isRolling = true
        rollTimer = 0
        cooldownTimer = ROLL_COOLDOWN

        local dir = Vector.Zero
        if Input.IsActionPressed(ButtonAction.ACTION_LEFT, player.ControllerIndex) then dir.X = -1 end
        if Input.IsActionPressed(ButtonAction.ACTION_RIGHT, player.ControllerIndex) then dir.X = 1 end
        if Input.IsActionPressed(ButtonAction.ACTION_UP, player.ControllerIndex) then dir.Y = -1 end
        if Input.IsActionPressed(ButtonAction.ACTION_DOWN, player.ControllerIndex) then dir.Y = 1 end

        if dir:Length() == 0 then
            dir = Vector(player:GetFireDirection().X, player:GetFireDirection().Y)
        end
        dir = dir:Normalized()

        player.Velocity = dir * 12
        SFXManager():Play(SoundEffect.SOUND_DASH, 0.7, 0, false, 1.0)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0,
            player.Position, Vector.Zero, player):SetTimeout(8)
    end
end)

Isaac.DebugString("DodgeRoll loaded! Roll like a boss!")
