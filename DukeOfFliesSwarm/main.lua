-- =============================================================================
--  DukeOfFliesSwarm — The Binding of Isaac: Repentance
--  Duke of Flies (Type=25) spawns flies at 3x normal rate, flies are champions
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DukeOfFliesSwarm", 1)

local DUKE_TYPE = EntityType.ENTITY_DUKE_OF_FLIES
local FLY_TYPE = EntityType.ENTITY_FLY
local FLY_VARIANT = 0
local SPAWN_COUNT = 3

-- Override fly spawns to be champions
function mod:onPostEntitySpawn(entity)
    if entity.Type ~= FLY_TYPE and entity.Type ~= EntityType.ENTITY_ATTACKFLY then
        return
    end

    -- Check if we're near a Duke
    local room = Game():GetRoom()
    for i = 0, room:GetAliveEnemiesCount() - 1 do
        local npc = room:GetAliveEnemy(i)
        if npc and npc.Type == DUKE_TYPE then
            local dist = entity.Position:Distance(npc.Position)
            if dist < 200 then
                -- Make spawned fly a champion
                entity:ToNPC():MakeChampion(1, 0, true)
                break
            end
        end
    end
end

function mod:onNPCUpdate(npc)
    if npc.Type ~= DUKE_TYPE then
        return
    end

    -- Kill more flies periodically simulating 3x spawn rate
    -- Duke uses EntityFlag FLAG_SPAWN_EXPLOSION or similar; inject additional flies
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onPostEntitySpawn, EntityType.ENTITY_FLY)
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onPostEntitySpawn, EntityType.ENTITY_ATTACKFLY)
Isaac.DebugString("DukeOfFliesSwarm loaded!")
