-- =============================================================================
--  SlideAccelerate - The Binding of Isaac: Repentance
--  Slide enemy accelerates over time and leaves creep trail at max speed
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SlideAccelerate", 1)
local SLIDE_TYPE = 218 -- EntityType.ENTITY_SLIDE
local ACCEL_RATE = 0.05
local MAX_SPEED = 8.0
local CREEP_DROP_RATE = 8
local slideData = {}

local function onNPCUpdate(_, entity)
    if entity.Type ~= SLIDE_TYPE or not entity:Exists() then
        return
    end

    local idx = entity.Index
    if not slideData[idx] then
        slideData[idx] = {speed = 2.0, creepTimer = 0}
    end

    local data = slideData[idx]

    -- Accelerate
    data.speed = math.min(data.speed + ACCEL_RATE, MAX_SPEED)

    -- Maintain current direction, accelerate in it
    local vel = entity.Velocity
    if vel:Length() > 0 then
        entity.Velocity = vel:Normalized() * data.speed
    else
        -- If stationary, pick a random direction
        local angle = math.random() * math.pi * 2
        entity.Velocity = Vector(math.cos(angle), math.sin(angle)) * data.speed
    end

    -- At max speed, leave green creep trail
    if data.speed >= MAX_SPEED then
        data.creepTimer = data.creepTimer + 1
        if data.creepTimer >= CREEP_DROP_RATE then
            data.creepTimer = 0
            local room = Game():GetRoom()
            if room then
                local pos = entity.Position
                local gridIdx = room:GetGridIndex(pos)
                local existing = room:GetGridEntity(gridIdx)
                if not existing then
                    Isaac.GridSpawn(GridEntityType.GRID_RED, 0, pos, false)
                end
            end
        end

        -- Visual feedback at max speed
        entity:SetColor(Color(1, 0.5, 0.2, 1, 0, 0, 0), 3, 0, false, true)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("SlideAccelerate loaded!")
