-- =============================================================================
--  Floor Champion Theme - The Binding of Isaac: Repentance
--  Each floor has a dedicated champion color theme applied to all spawned enemies.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SubtypeChampionMix", 1)

-- Champion color IDs (0 = no champion, 1-14 = various champion types)
local championPool = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15}
local floorChampion = {}  -- Map: floorStage -> champion color
local currentFloorChampion = 0

-- Boss champions (limited subset that works on bosses)
local bossChampionPool = {1, 2, 5, 6, 8, 9, 10, 11}

-- Entities that should NOT be converted to champions
local blacklistTypes = {
    [EntityType.ENTITY_PLAYER] = true,
    [EntityType.ENTITY_TEAR] = true,
    [EntityType.ENTITY_PROJECTILE] = true,
    [EntityType.ENTITY_PICKUP] = true,
    [EntityType.ENTITY_EFFECT] = true,
}

local function getFloorChampion()
    local level = Game():GetLevel()
    local stage = level:GetStage()
    local stageType = level:GetStageType()

    -- Create unique key for this floor
    local key = stage * 100 + stageType

    if not floorChampion[key] then
        -- Deterministic champion color based on floor seed
        local seed = level:GetSeeds():GetStartSeed()
        local rng = RNG()
        rng:SetSeed(seed + key, stage)
        floorChampion[key] = championPool[(rng:RandomInt(#championPool)) + 1]
    end

    return floorChampion[key]
end

local function onEntitySpawn(_, entity)
    if blacklistTypes[entity.Type] then return end
    if not entity:IsVulnerableEnemy() then return end
    if entity:IsBoss() and entity.MaxHitPoints > 200 then return end -- Skip major bosses

    -- Update floor champion each spawn (refreshes on floor change)
    currentFloorChampion = getFloorChampion()

    -- Only apply to enemies without existing champion color
    if entity:GetChampionColorIdx() == 0 then
        local champColor = currentFloorChampion
        if entity:IsBoss() then
            -- Bosses get a rotated champion from the boss pool
            local bossIdx = (math.abs(entity.InitSeed) % #bossChampionPool) + 1
            champColor = bossChampionPool[bossIdx]
        end
        entity:SetChampionColor(champColor, true)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, onEntitySpawn)
Isaac.DebugString("SubtypeChampionMix loaded!")
