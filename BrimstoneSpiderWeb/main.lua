-- ==========================================================================
--  BrimstoneSpiderWeb - The Binding of Isaac: Repentance
--  Brimstone Spider shoots web lines like mini brimstone lasers
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("BrimstoneSpiderWeb", 1)
local game = Game()
local SPIDER_TYPE = EntityType.ENTITY_SPIDER
local BRIMSTONE_SPIDER_VARIANT = 4

function mod:webUpdate(_, npc)
    if npc.Type ~= SPIDER_TYPE or npc.Variant ~= BRIMSTONE_SPIDER_VARIANT then return end
    local player = game:GetPlayer(0)
    if not player then return end
    if npc.FrameCount % 90 == 0 and npc.Position:Distance(player.Position) < 350 then
        local params = ProjectileParams()
        params.Variant = ProjectileVariant.PROJECTILE_BRIMSTONE
        params.BulletFlags = ProjectileFlags.LASER_SHOT
        params.Scale = 0.3
        local dir = (player.Position - npc.Position):Normalized()
        npc:FireProjectiles(npc.Position, dir:Resized(5), params)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.webUpdate, SPIDER_TYPE)
Isaac.DebugString("BrimstoneSpiderWeb loaded!")
