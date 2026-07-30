-- =============================================================================
--  SwarmerHiveMind - The Binding of Isaac: Repentance
--  Swarmer spawns 3 extra attack flies every 10 seconds
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SwarmerHiveMind", 1)
local SWARMER_TYPE = 205 -- EntityType.ENTITY_SWARMER
local SPAWN_INTERVAL = 300 -- 10 seconds at 30fps
local swarmTimers = {}

local function onNPCUpdate(_, entity)
    if entity.Type ~= SWARMER_TYPE or not entity:Exists() then
        return
    end

    local idx = entity.Index
    if not swarmTimers[idx] then
        swarmTimers[idx] = SPAWN_INTERVAL
    end

    swarmTimers[idx] = swarmTimers[idx] - 1
    if swarmTimers[idx] <= 0 then
        swarmTimers[idx] = SPAWN_INTERVAL

        local pos = entity.Position
        for i = 1, 3 do
            local angle = (i - 1) * (math.pi * 2 / 3) + math.random() * 0.5
            local spawnPos = pos + Vector(math.cos(angle) * 30, math.sin(angle) * 30)
            local fly = Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0, 0, spawnPos, Vector(math.cos(angle), math.sin(angle)) * 3, entity)
            if fly then
                fly:AddEntityFlags(EntityFlag.FLAG_SLOW)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("SwarmerHiveMind loaded!")
