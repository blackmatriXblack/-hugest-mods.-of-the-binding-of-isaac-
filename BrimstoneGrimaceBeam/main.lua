-- ==========================================================================
--  BrimstoneGrimaceBeam - The Binding of Isaac: Repentance
--  Brimstone Grimace fires intermittent brimstone beams at player
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("BrimstoneGrimaceBeam", 1)
local game = Game()
local GRIMACE_TYPE = EntityType.ENTITY_GRIMACE
local BRIMSTONE_VARIANT = 3

function mod:beamUpdate(_, npc)
    if npc.Type ~= GRIMACE_TYPE or npc.Variant ~= BRIMSTONE_VARIANT then return end
    local player = game:GetPlayer(0)
    if not player then return end
    if npc.FrameCount % 120 == 0 and npc.Position:Distance(player.Position) < 500 then
        local params = ProjectileParams()
        params.Variant = ProjectileVariant.PROJECTILE_BRIMSTONE
        params.BulletFlags = ProjectileFlags.LASER_SHOT
        npc:FireProjectiles(npc.Position, (player.Position - npc.Position):Resized(10), params)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.beamUpdate, GRIMACE_TYPE)
Isaac.DebugString("BrimstoneGrimaceBeam loaded!")
