-- ==========================================================================
--  MortisSkullThrow - The Binding of Isaac: Repentance
--  Mortis throws bouncing skulls that ricochet off walls
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("MortisSkullThrow", 1)
local game = Game()
local MORTIS_TYPE = EntityType.ENTITY_MORTIS

function mod:skullThrowUpdate(_, npc)
    if npc.Type ~= MORTIS_TYPE then return end
    local player = game:GetPlayer(0)
    if not player then return end
    if npc.FrameCount % 80 == 0 and npc.Position:Distance(player.Position) < 400 then
        local toPlayer = (player.Position - npc.Position):Normalized()
        local params = ProjectileParams()
        params.Variant = ProjectileVariant.PROJECTILE_BONE
        params.BulletFlags = ProjectileFlags.BOUNCE_WALLS | ProjectileFlags.HIT_ENEMIES
        npc:FireProjectiles(npc.Position, toPlayer:Resized(7), params)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.skullThrowUpdate, MORTIS_TYPE)
Isaac.DebugString("MortisSkullThrow loaded!")
