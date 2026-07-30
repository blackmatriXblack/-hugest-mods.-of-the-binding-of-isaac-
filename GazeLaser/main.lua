-- ==========================================================================
--  GazeLaser - The Binding of Isaac: Repentance
--  Gaze enemy fires continuous tracking laser that follows player
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("GazeLaser", 1)
local game = Game()
local GAZE_TYPE = EntityType.ENTITY_GAZE

function mod:laserUpdate(_, npc)
    if npc.Type ~= GAZE_TYPE then return end
    local player = game:GetPlayer(0)
    if not player then return end
    if npc.FrameCount % 5 == 0 and npc.Position:Distance(player.Position) < 400 then
        local params = ProjectileParams()
        params.Variant = ProjectileVariant.PROJECTILE_LASER
        params.BulletFlags = ProjectileFlags.LASER_SHOT
        local dir = (player.Position - npc.Position):Normalized()
        npc:FireProjectiles(npc.Position, dir:Resized(8), params)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.laserUpdate, GAZE_TYPE)
Isaac.DebugString("GazeLaser loaded!")
