-- ==========================================================================
--  DopleCopycat - The Binding of Isaac: Repentance
--  Dople copies player's appearance, speed, and tear pattern exactly
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("DopleCopycat", 1)
local game = Game()
local DOPLE_TYPE = EntityType.ENTITY_DOPLE

function mod:copycatUpdate(_, npc)
    if npc.Type ~= DOPLE_TYPE then return end
    local player = game:GetPlayer(0)
    if not player then return end
    -- Copy player velocity and direction exactly
    npc.Velocity = player.Velocity
    -- Mirror the player's tear direction as a projectile spawn
    if npc.FrameCount % 30 == 0 then
        local tearDir = player:GetFireDirection()
        local params = ProjectileParams()
        params.Variant = ProjectileVariant.PROJECTILE_NORMAL
        params.BulletFlags = ProjectileFlags.BOUNCE_NONE
        npc:FireProjectiles(npc.Position, Vector(math.cos(tearDir:ToAngle()), math.sin(tearDir:ToAngle())):Resized(6), params)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.copycatUpdate, DOPLE_TYPE)
Isaac.DebugString("DopleCopycat loaded!")
