-- =============================================================================
--  GehennaLava - The Binding of Isaac: Repentance
--  Gehenna floors spawn extra lava pools and red creep hazards in rooms
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GehennaLava", 1)

local function IsGehenna()
    local level = Game():GetLevel()
    -- Gehenna is accessed from Mines/Ashpit (stage 3 alt) via special door
    local stage = level:GetStage()
    return (stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2)
       and level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B
end

local function SpawnLavaHazards()
    if not IsGehenna() then return end

    local room = Game():GetRoom()
    local center = room:GetCenterPos()
    local shape = room:GetRoomShape()

    -- Spawn 3-8 lava/fire grid entities in room
    local count = math.random(3, 8)
    for i = 1, count do
        local pos = Vector(
            center.X + math.random(-120, 120),
            center.Y + math.random(-120, 120)
        )

        -- Alternate between fireplaces and red poop (lava hazards)
        if math.random(1, 100) <= 50 then
            Isaac.GridSpawn(GridEntityType.GRID_FIREPLACE, 0, pos, true)
        else
            Isaac.GridSpawn(GridEntityType.GRID_POOP_RED, 0, pos, true)
        end
    end

    -- Extra red creep as lava flow
    if math.random(1, 100) <= 40 then
        for i = 1, 3 do
            local creepPos = Vector(
                center.X + math.random(-150, 150),
                center.Y + math.random(-150, 150)
            )
            local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, creepPos, Vector.Zero, nil)
            if creep then
                creep:SetTimeout(360 + math.random(0, 300)) -- 12-22 seconds
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, SpawnLavaHazards)
Isaac.DebugString("GehennaLava loaded!")
