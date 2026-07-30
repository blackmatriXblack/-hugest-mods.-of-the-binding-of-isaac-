-- =============================================================================
--  FatFlySpawner - The Binding of Isaac: Repentance
--  Fat Fly periodically spawns 2 small attack flies to harass the player
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FatFlySpawner", 1)
local FAT_FLY_TYPE = 33 -- EntityType.ENTITY_FATFLY
local SPAWN_INTERVAL = 180 -- frames (~6 seconds)
local spawnTimers = {} -- entity index -> frames remaining

local function onNPCUpdate(_, entity)
    if entity.Type ~= FAT_FLY_TYPE or not entity:Exists() then
        return
    end

    local idx = entity.Index
    if not spawnTimers[idx] then
        spawnTimers[idx] = SPAWN_INTERVAL
    end

    spawnTimers[idx] = spawnTimers[idx] - 1
    if spawnTimers[idx] <= 0 then
        spawnTimers[idx] = SPAWN_INTERVAL

        local room = Game():GetRoom()
        if room then
            local pos = entity.Position
            for i = 1, 2 do
                local fly = Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0, 0, pos, Vector(0, 0), entity)
                if fly then
                    local offset = Vector(math.random(-30, 30), math.random(-30, 30))
                    fly.Position = pos + offset
                    fly:AddEntityFlags(EntityFlag.FLAG_SLOW)
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("FatFlySpawner loaded!")
