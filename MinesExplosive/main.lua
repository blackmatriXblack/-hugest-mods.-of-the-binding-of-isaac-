-- =============================================================================
--  MinesExplosive - The Binding of Isaac: Repentance
--  All enemies on Mines and Ashpit floors have +15% chance to drop a bomb on death
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MinesExplosive", 1)

local function IsMinesOrAshpit()
    local level = Game():GetLevel()
    local stageType = level:GetStageType()
    -- Mines = stage 3, normal type; Ashpit = stage 3, REPENTANCE type
    return level:GetStage() == LevelStage.STAGE3_1 or level:GetStage() == LevelStage.STAGE3_2
end

local function OnNpcDeath(npc)
    if not IsMinesOrAshpit() then return end
    if not npc:IsVulnerableEnemy() then return end

    -- 15% chance to drop a bomb on death
    if math.random(1, 100) <= 15 then
        local bomb = Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_BOMB,
            BombSubType.BOMB_NORMAL,
            npc.Position,
            Vector(math.random(-2, 2), math.random(-2, 2)),
            nil
        )
        -- Also spawn bomb with double variant chance
        if math.random(1, 100) <= 30 and bomb then
            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_BOMB,
                BombSubType.BOMB_DOUBLEPACK,
                Vector(npc.Position.X + 10, npc.Position.Y + 10),
                Vector.Zero,
                nil
            )
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, OnNpcDeath)
Isaac.DebugString("MinesExplosive loaded!")
