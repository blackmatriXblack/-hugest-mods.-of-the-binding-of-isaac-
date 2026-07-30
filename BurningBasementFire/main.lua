-- =============================================================================
--  BurningBasementFire - The Binding of Isaac: Repentance
--  Burning Basement floors have 50% more fireplaces and fire hazards on entry
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BurningBasementFire", 1)

local function IsBurningBasement()
    local level = Game():GetLevel()
    return level:GetStage() == LevelStage.STAGE1_1 or level:GetStage() == LevelStage.STAGE1_2
       and level:GetStageType() == StageType.STAGETYPE_REPENTANCE
end

local function SpawnExtraFireplaces()
    if not IsBurningBasement() then return end

    -- 50% chance per room to add extra fireplaces
    if math.random(1, 100) > 50 then return end

    local room = Game():GetRoom()
    local center = room:GetCenterPos()
    local shape = room:GetRoomShape()

    -- Spawn 2-4 fireplaces in random corners of the room
    local count = math.random(2, 4)
    for i = 1, count do
        local offsetX = math.random(-3, 3) * 40
        local offsetY = math.random(-3, 3) * 40
        local pos = Vector(center.X + offsetX, center.Y + offsetY)
        Isaac.GridSpawn(GridEntityType.GRID_FIREPLACE, 0, pos, true)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, SpawnExtraFireplaces)
Isaac.DebugString("BurningBasementFire loaded!")
