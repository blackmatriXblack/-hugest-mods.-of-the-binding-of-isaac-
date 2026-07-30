-- =============================================================================
--  GurdyJrPair - The Binding of Isaac: Repentance
--  Gurdy Jr. always spawns in pairs - one charges, one shoots
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GurdyJrPair", 1)
local GURDY_JR_ID = 263
local spawnedThis = false

function mod:OnEntitySpawn(entity)
    if entity.Type ~= GURDY_JR_ID then return end
    if entity.Variant ~= 0 then return end
    if spawnedThis then
        spawnedThis = false
        return
    end

    -- Prevent infinite recursion
    spawnedThis = true

    -- Spawn second Gurdy Jr. offset from the first
    local spawnPos = entity.Position + Vector(math.random(-80, 80), math.random(-80, 80))
    -- Clamp to room bounds
    local room = Game():GetRoom()
    spawnPos = room:FindFreePickupSpawnPosition(spawnPos, 0, true)

    local twin = Isaac.Spawn(EntityType.ENTITY_GURDY_JR, 0, 0, spawnPos, Vector(0, 0), entity.SpawnerEntity)
    if twin then
        -- One charges (aggressive AI), one shoots (ranged AI)
        -- Slight color tint to distinguish
        twin:AddEntityFlags(EntityFlag.FLAG_GREEN)
        twin.Pathfinder:AddEntityFlags(EntityFlag.FLAG_GREEN)
    end

    spawnedThis = false
end

-- Make the "shooter" Gurdy Jr. fire tears at the player periodically
function mod:OnNPCUpdate(npc)
    if npc.Type ~= GURDY_JR_ID then return end
    if not npc:IsActiveEnemy() then return end

    -- Only the marked (green-tinted) one shoots
    if not npc:HasEntityFlags(EntityFlag.FLAG_GREEN) then return end

    local frame = Game():GetFrameCount()
    if frame % 45 == 0 then
        local player = Isaac.GetPlayer(0)
        if player and player:Exists() then
            local dir = (player.Position - npc.Position):Normalized()
            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, npc.Position, dir * 6, npc):ToTear()
            if tear then
                tear:AddTearFlags(TearFlags.TEAR_HOMING)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.OnEntitySpawn)
mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("GurdyJrPair loaded!")
