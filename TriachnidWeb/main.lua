-- =============================================================================
--  Triachnid Web Brood - The Binding of Isaac: Repentance
--  Triachnid's web projectile spawns 2 small spiders on impact.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TriachnidWeb", 1)

local TRIACHNID_TYPE = 66    -- EntityType.ENTITY_TRIACHNID
local SPIDER_TYPE = 25       -- EntityType.ENTITY_SPIDER
local SMALL_SPIDER = 0

local function onNPCUpdate(_, npc)
    if npc.Type ~= TRIACHNID_TYPE then return end
    if npc:IsDead() then return end

    -- Check for web projectiles near Triachnid and spawn spiders
    if npc.State == NpcState.STATE_ATTACK2 then
        local entities = Isaac.GetRoomEntities()
        for _, ent in ipairs(entities) do
            if ent.Type == EntityType.ENTITY_PROJECTILE then
                local proj = ent:ToProjectile()
                if proj and proj.Parent and proj.Parent.Index == npc.Index then
                    -- Spawn 2 small spiders at the projectile's position periodically
                    if proj.FrameCount % 4 == 0 and proj.FrameCount <= 12 then
                        local offset = Vector(math.random(-15, 15), math.random(-15, 15))
                        Isaac.Spawn(SPIDER_TYPE, SMALL_SPIDER, 0,
                            proj.Position + offset, Vector.Zero, npc)
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("TriachnidWeb loaded!")
