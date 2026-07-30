-- =============================================================================
--  Rag Man Resurrection - The Binding of Isaac: Repentance
--  Dead spiders have 20% chance to revive as smaller swarm spiders.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RagManRevive", 1)

local SPIDER_TYPE = 25      -- EntityType.ENTITY_SPIDER
local SMALL_SPIDER = 0
local REVIVE_CHANCE = 20    -- 20%

local function onNPCDeath(_, npc)
    -- Only trigger for spiders in rooms containing Rag Man
    if npc.Type ~= SPIDER_TYPE then return end

    -- Check if Rag Man is still alive in the room
    local entities = Isaac.GetRoomEntities()
    local ragManAlive = false
    for _, ent in ipairs(entities) do
        if ent.Type == 75 and not ent:IsDead() then -- EntityType.ENTITY_RAG_MAN
            ragManAlive = true
            break
        end
    end

    if ragManAlive and math.random(1, 100) <= REVIVE_CHANCE then
        -- Revive as 2 smaller spiders at the same position
        for j = 1, 2 do
            local offset = Vector(math.random(-10, 10), math.random(-10, 10))
            local baby = Isaac.Spawn(SPIDER_TYPE, SMALL_SPIDER, 0,
                npc.Position + offset, Vector(math.random(-1, 1), math.random(-1, 1)), nil)
            if baby then
                baby.HitPoints = math.max(1, math.floor(baby.MaxHitPoints * 0.4))
                baby.Scale = 0.55
                baby:AddEntityFlags(EntityFlag.FLAG_APPEAR, false)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, onNPCDeath)
Isaac.DebugString("RagManRevive loaded!")
