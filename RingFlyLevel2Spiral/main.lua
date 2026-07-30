-- ==========================================================================
--  RingFlyLevel2Spiral - The Binding of Isaac: Repentance
--  Level 2 Ring Fly creates a spiral of projectiles outward
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("RingFlyLevel2Spiral", 1)
local game = Game()
local RING_FLY_TYPE = EntityType.ENTITY_RING_FLY

function mod:spiralUpdate(_, npc)
    if npc.Type ~= RING_FLY_TYPE or npc.Variant ~= 2 then return end
    if npc.FrameCount % 30 == 0 then
        local angle = (npc.FrameCount % 360) * math.pi / 180
        local params = ProjectileParams()
        params.Variant = ProjectileVariant.PROJECTILE_NORMAL
        params.BulletFlags = ProjectileFlags.SPIRAL
        local dir = Vector(math.cos(angle), math.sin(angle))
        npc:FireProjectiles(npc.Position, dir:Resized(5), params)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.spiralUpdate, RING_FLY_TYPE)
Isaac.DebugString("RingFlyLevel2Spiral loaded!")
