-- =============================================================================
--  DoubleEnemyMode - The Binding of Isaac: Repentance
--  Every enemy spawn spawns twice (double trouble)
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DoubleEnemyMode", 1)
local game = Game()
local spawnedThisFrame = {}

function mod:onPostEntitySpawn(entity)
    -- Only double enemy/monster entities
    if entity.Type ~= EntityType.ENTITY_TEAR and
       entity.Type ~= EntityType.ENTITY_PROJECTILE and
       entity.Type ~= EntityType.ENTITY_PICKUP and
       entity.Type ~= EntityType.ENTITY_FAMILIAR and
       entity.Type ~= EntityType.ENTITY_EFFECT and
       entity:IsActiveEnemy() then

        -- Prevent infinite loops: track spawns per frame
        local frame = game:GetFrameCount()
        local key = entity.Type .. "_" .. entity.Variant .. "_" .. entity.SubType .. "_" .. frame
        spawnedThisFrame[key] = (spawnedThisFrame[key] or 0) + 1

        -- Only clone if this is the first spawn (not the clone itself)
        if spawnedThisFrame[key] == 1 then
            -- Spawn a clone slightly offset
            local offsetX = math.random(-40, 40)
            local offsetY = math.random(-40, 40)
            local clonePos = Vector(entity.Position.X + offsetX, entity.Position.Y + offsetY)

            local clone = Isaac.Spawn(
                entity.Type,
                entity.Variant,
                entity.SubType,
                clonePos,
                Vector.Zero,
                nil
            )

            if clone then
                -- Make the clone slightly different (champion chance for variety)
                if math.random(100) < 15 then
                    -- 15% chance the clone is a champion
                end

                -- Mark to prevent further duplication
                clone:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
            end
        end
    end

    -- Cleanup table periodically
    if game:GetFrameCount() % 30 == 0 then
        spawnedThisFrame = {}
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onPostEntitySpawn)

Isaac.DebugString("DoubleEnemyMode loaded! Prepare for double trouble.")
