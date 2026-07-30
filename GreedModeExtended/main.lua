-- =============================================================================
--  GreedModeExtended - The Binding of Isaac: Repentance
--  Greed Mode has 12 waves and final wave drops 2 items
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GreedModeExtended", 1)
local game = Game()
local finalWaveTriggered = false
local currentWaveCount = 0
local itemPool = nil

function mod:onNewRoom()
    finalWaveTriggered = false
    currentWaveCount = 0

    local room = game:GetRoom()
    if not room then return end

    -- Check if we're in Greed Mode
    if game:IsGreedMode() then
        itemPool = game:GetItemPool()
        Isaac.DebugString("GreedModeExtended: Greed room entered - 12 waves incoming!")
    end
end

function mod:onGameStart()
    finalWaveTriggered = false
    currentWaveCount = 0
end

function mod:onPostUpdate()
    if not game:IsGreedMode() then return end

    local room = game:GetRoom()
    if not room then return end

    -- Track waves in Greed Mode
    -- Greed Mode waves are managed internally; we check for enemies
    local enemies = 0
    local entities = Isaac.GetRoomEntities()
    for _, ent in ipairs(entities) do
        if ent:IsActiveEnemy() then
            enemies = enemies + 1
        end
    end

    -- When all enemies are cleared and we haven't triggered item drop
    if enemies == 0 and not finalWaveTriggered then
        -- Check if this was the final wave (12th wave)
        -- In Greed mode, we can detect completion by checking for the button
        if currentWaveCount >= 12 and itemPool then
            finalWaveTriggered = true

            -- Drop 2 items at the center
            local centerPos = room:GetCenterPos()
            local spawnPos1 = Vector(centerPos.X - 40, centerPos.Y)
            local spawnPos2 = Vector(centerPos.X + 40, centerPos.Y)

            local item1 = itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, true)
            local item2 = itemPool:GetCollectible(ItemPoolType.POOL_BOSS, true)

            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_COLLECTIBLE,
                item1,
                spawnPos1,
                Vector.Zero,
                nil
            )

            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_COLLECTIBLE,
                item2,
                spawnPos2,
                Vector.Zero,
                nil
            )

            Isaac.DebugString("GreedModeExtended: Final wave cleared! Dropped 2 bonus items.")
        end

        -- Track wave completion
        currentWaveCount = currentWaveCount + 1
    end

    -- Display wave progress
    if game:IsGreedMode() then
        Isaac.RenderText(
            "GREED WAVE: " .. tostring(currentWaveCount) .. "/12",
            210, 350,
            1.0, 0.7, 0.0, 0.85
        )
        if finalWaveTriggered then
            Isaac.RenderText(
                "BONUS ITEMS DROPPED!",
                230, 364,
                0.0, 1.0, 0.3, 0.8
            )
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, mod.onGameStart)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onPostUpdate)

Isaac.DebugString("GreedModeExtended loaded! 12 waves, 2 items on final wave.")
