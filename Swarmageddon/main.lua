-- ==========================================================================
--  Swarmageddon - The Binding of Isaac: Repentance
--  Every room spawns 5x the normal enemy count
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("Swarmageddon", 1)
local game = Game()
local spawnedEntities = {}

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, function(_, entity)
    if not entity:IsEnemy() then return end
    if entity:IsBoss() then return end

    -- Prevent infinite recursion by tracking what we spawn
    local spawnKey = entity.InitSeed
    if spawnedEntities[spawnKey] then
        spawnedEntities[spawnKey] = nil
        return
    end

    -- Mark as original so we don't clone our clones
    spawnedEntities[spawnKey] = true

    -- Spawn 4 additional copies (total 5x)
    for i = 1, 4 do
        local offsetX = math.random(-50, 50)
        local offsetY = math.random(-50, 50)
        local clonePos = entity.Position + Vector(offsetX, offsetY)

        if game:GetRoom():IsPositionInRoom(clonePos, 0) then
            local clone = Isaac.Spawn(entity.Type, entity.Variant, entity.SubType,
                clonePos, Vector(math.random(-2, 2), math.random(-2, 2)), nil)
            if clone then
                clone.HitPoints = entity.HitPoints
                -- Small chance for champion variant
                if math.random() < 0.08 then
                    clone:MakeChampion(math.random(0, 9), EntityType.ENTITY_EFFECT, 0, true)
                end
            end
        end
    end
end)

-- Clean up tracker on new room
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    spawnedEntities = {}
end)

Isaac.DebugString("Swarmageddon loaded!")
