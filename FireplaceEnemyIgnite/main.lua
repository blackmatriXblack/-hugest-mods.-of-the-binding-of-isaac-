-- ==========================================================================
--  FireplaceEnemyIgnite - The Binding of Isaac: Repentance
--  Fireplace enemy sends flame waves across the room
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("FireplaceEnemyIgnite", 1)
local game = Game()
local FIREPLACE_TYPE = EntityType.ENTITY_FIREPLACE

function mod:igniteUpdate(_, npc)
    if npc.Type ~= FIREPLACE_TYPE then return end
    if npc.FrameCount % 180 == 0 then
        for i = 0, 3 do
            local angle = i * math.pi / 2
            local dir = Vector(math.cos(angle), math.sin(angle))
            local params = ProjectileParams()
            params.Variant = ProjectileVariant.PROJECTILE_FIRE
            params.BulletFlags = ProjectileFlags.BOUNCE_WALLS
            npc:FireProjectiles(npc.Position, dir:Resized(4), params)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.igniteUpdate, FIREPLACE_TYPE)
Isaac.DebugString("FireplaceEnemyIgnite loaded!")
