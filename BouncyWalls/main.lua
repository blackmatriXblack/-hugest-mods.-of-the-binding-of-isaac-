-- ==========================================================================
--  BouncyWalls - The Binding of Isaac: Repentance
--  Room walls bounce the player away on contact — like bumper cars!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("BouncyWalls", 1)
local BOUNCE_POWER = 8
local BOUNCE_COOLDOWN = {}
local COOLDOWN_FRAMES = 8

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    local room = Game():GetRoom()
    local tl = room:GetTopLeftPos()
    local br = room:GetBottomRightPos()
    local pos = player.Position
    local idx = player.ControllerIndex

    BOUNCE_COOLDOWN[idx] = (BOUNCE_COOLDOWN[idx] or 0) - 1
    if BOUNCE_COOLDOWN[idx] > 0 then return end

    local bounced = false
    local vel = player.Velocity

    local margin = 15
    if pos.X <= tl.X + margin then
        vel = Vector(math.abs(vel.X) + BOUNCE_POWER, vel.Y)
        bounced = true
    elseif pos.X >= br.X - margin then
        vel = Vector(-math.abs(vel.X) - BOUNCE_POWER, vel.Y)
        bounced = true
    end
    if pos.Y <= tl.Y + margin then
        vel = Vector(vel.X, math.abs(vel.Y) + BOUNCE_POWER)
        bounced = true
    elseif pos.Y >= br.Y - margin then
        vel = Vector(vel.X, -math.abs(vel.Y) - BOUNCE_POWER)
        bounced = true
    end

    if bounced then
        player.Velocity = vel
        BOUNCE_COOLDOWN[idx] = COOLDOWN_FRAMES
        SFXManager():Play(SoundEffect.SOUND_BOSS2INTRO, 0.4, 0, false, 1.5)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPARKLE, 0,
            player.Position, Vector.Zero, player):SetTimeout(10)
    end
end)

Isaac.DebugString("BouncyWalls loaded! BOING!")
