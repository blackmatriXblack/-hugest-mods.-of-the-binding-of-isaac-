-- ==========================================================================
--  EmbryoHatch - The Binding of Isaac: Repentance
--  Embryo hatches into a random medium enemy when room is 50% cleared
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("EmbryoHatch", 1)
local game = Game()
local EMBRYO_TYPE = EntityType.ENTITY_EMBRYO
local hasHatched = {}
local enemyPool = {EntityType.ENTITY_GAPER, EntityType.ENTITY_HORF, EntityType.ENTITY_CLOTTY, EntityType.ENTITY_MULLIGAN, EntityType.ENTITY_PSY_TUMOR}

function mod:hatchUpdate(_, npc)
    if npc.Type ~= EMBRYO_TYPE then return end
    local idx = GetPtrHash(npc)
    if hasHatched[idx] then return end
    local room = game:GetRoom()
    local alive = room:GetAliveEnemiesCount()
    local maxEnemies = room:GetSpawnedEnemiesCount()
    if maxEnemies > 0 and alive <= maxEnemies * 0.5 then
        hasHatched[idx] = true
        local chosenEnemy = enemyPool[math.random(#enemyPool)]
        local spawned = Isaac.Spawn(chosenEnemy, 0, 0, npc.Position, Vector.Zero, npc)
        if spawned then spawned:AddEntityFlags(EntityFlag.FLAG_CHASE) end
        npc:Kill()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.hatchUpdate, EMBRYO_TYPE)
Isaac.DebugString("EmbryoHatch loaded!")
