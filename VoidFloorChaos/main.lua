-- =============================================================================
--  VoidFloorChaos - The Binding of Isaac: Repentance
--  The Void spawns enemies from all floor pools at random for maximum chaos
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("VoidFloorChaos", 1)

local function IsTheVoid()
    local level = Game():GetLevel()
    return level:GetStage() == LevelStage.STAGE11
end

-- Pool of enemy types from all chapters
local chaosEnemyPool = {
    -- Basement enemies
    {EntityType.ENTITY_FLY, 0, 0},
    {EntityType.ENTITY_GAPER, 0, 0},
    {EntityType.ENTITY_HORF, 0, 0},
    -- Caves enemies
    {EntityType.ENTITY_MULLIGAN, 0, 0},
    {EntityType.ENTITY_CLOTTY, 0, 0},
    {EntityType.ENTITY_MULLIBOOM, 0, 0},
    -- Depths enemies
    {EntityType.ENTITY_MOM_HAND, 0, 0},
    {EntityType.ENTITY_KNIGHT, 0, 0},
    {EntityType.ENTITY_GLOOBIN, 0, 0},
    -- Womb enemies
    {EntityType.ENTITY_GURGLING, 0, 0},
    {EntityType.ENTITY_LUMP, 0, 0},
    -- Sheol enemies
    {EntityType.ENTITY_ADULT_LEECH, 0, 0},
    {EntityType.ENTITY_TWIN_LEECH, 0, 0},
    -- Cathedral enemies
    {EntityType.ENTITY_HOLY_LEECH, 0, 0},
    -- Misc
    {EntityType.ENTITY_SPIDER, 0, 0},
    {EntityType.ENTITY_BOOM_FLY, 0, 0},
    {EntityType.ENTITY_ATTACK_FLY, 0, 0},
    {EntityType.ENTITY_POOTER, 0, 0},
    {EntityType.ENTITY_HOST, 0, 0},
}

local function SpawnChaosEnemies()
    if not IsTheVoid() then return end

    local room = Game():GetRoom()
    local center = room:GetCenterPos()

    -- Spawn 3-6 random enemies from the chaos pool in each room
    local count = math.random(3, 6)
    for i = 1, count do
        local enemy = chaosEnemyPool[math.random(1, #chaosEnemyPool)]
        local pos = Vector(
            center.X + math.random(-150, 150),
            center.Y + math.random(-100, 100)
        )

        -- Check if position is valid (not inside a wall)
        if not room:IsPositionInWall(pos, 0) then
            Isaac.Spawn(enemy[1], enemy[2], enemy[3], pos, Vector.Zero, nil)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, SpawnChaosEnemies)
Isaac.DebugString("VoidFloorChaos loaded!")
