-- =============================================================================
--  FloodedCavesBubbles - The Binding of Isaac: Repentance
--  Flooded Caves occasionally bubble up items or pickups from the water
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FloodedCavesBubbles", 1)

local function IsFloodedCaves()
    local level = Game():GetLevel()
    local stage = level:GetStage()
    return (stage == LevelStage.STAGE2_1 or stage == LevelStage.STAGE2_2)
       and level:GetStageType() == StageType.STAGETYPE_REPENTANCE
end

local function SpawnWaterBubbles()
    if not IsFloodedCaves() then return end

    -- 35% chance per room to spawn bubbles
    if math.random(1, 100) > 35 then return end

    local room = Game():GetRoom()
    local center = room:GetCenterPos()

    -- Spawn 1-3 bubbles in random spots
    local bubbleCount = math.random(1, 3)
    for i = 1, bubbleCount do
        local offsetX = math.random(-80, 80)
        local offsetY = math.random(-80, 80)
        local pos = Vector(center.X + offsetX, center.Y + offsetY)

        -- Bubble effect: spat out pickup from water
        local pickups = {PickupVariant.PICKUP_HEART, PickupVariant.PICKUP_COIN,
                         PickupVariant.PICKUP_KEY, PickupVariant.PICKUP_BOMB,
                         PickupVariant.PICKUP_TAROTCARD}
        local variant = pickups[math.random(1, #pickups)]
        Isaac.Spawn(EntityType.ENTITY_PICKUP, variant, 0, pos, Vector(0, -3), nil)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SpawnWaterBubbles)
Isaac.DebugString("FloodedCavesBubbles loaded!")
