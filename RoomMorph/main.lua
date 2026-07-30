-- ==========================================================================
--  Room Morph - The Binding of Isaac: Repentance
--  Room layout changes every 15 seconds — walls shift obstacles move
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("RoomMorph", 1)
local game = Game()
local morphTimer = 0
local MORPH_DELAY = 450 -- 15 seconds
local roomObstacles = {}

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    morphTimer = 0
    roomObstacles = {}
    
    -- Record current room obstacles
    local room = game:GetRoom()
    local gridSize = room:GetGridSize()
    for x = 0, gridSize - 1 do
        for y = 0, gridSize - 1 do
            local idx = room:GetGridIndex(Vector(x * 40, y * 40))
            local gridEnt = room:GetGridEntity(idx)
            if gridEnt then
                local gType = gridEnt:GetType()
                if gType == GridEntityType.GRID_ROCK or
                   gType == GridEntityType.GRID_ROCKB or
                   gType == GridEntityType.GRID_ROCKT or
                   gType == GridEntityType.GRID_POOP then
                    table.insert(roomObstacles, {
                        idx = idx, type = gType, variant = gridEnt:GetVariant(),
                        pos = Vector(x * 40, y * 40)
                    })
                end
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    morphTimer = morphTimer + 1

    if morphTimer >= MORPH_DELAY then
        morphTimer = 0
        local room = game:GetRoom()
        
        -- Clear all existing obstacles
        local gridSize = room:GetGridSize()
        for x = 0, gridSize - 1 do
            for y = 0, gridSize - 1 do
                local idx = room:GetGridIndex(Vector(x * 40, y * 40))
                local gridEnt = room:GetGridEntity(idx)
                if gridEnt then
                    local gType = gridEnt:GetType()
                    if gType ~= GridEntityType.GRID_DECORATION and
                       gType ~= GridEntityType.GRID_WALL and
                       gType ~= GridEntityType.GRID_DOOR then
                        room:RemoveGridEntity(idx, 0, false)
                    end
                end
            end
        end

        -- Respawn obstacles in new random positions
        for _, obs in ipairs(roomObstacles) do
            local newX = math.random(2, gridSize - 3)
            local newY = math.random(2, gridSize - 3)
            local newIdx = room:GetGridIndex(Vector(newX * 40, newY * 40))
            local existing = room:GetGridEntity(newIdx)
            
            if existing and existing:GetType() == GridEntityType.GRID_NOTHING then
                room:SpawnGridEntity(newIdx, obs.type, obs.variant, 0, -1)
            end
        end

        Isaac.DebugString("Room has morphed! Layout changed.")
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if morphTimer > MORPH_DELAY - 150 then
        local seconds = math.ceil((MORPH_DELAY - morphTimer) / 30)
        Isaac.RenderText(string.format("Morph in %ds...", seconds),
            270, 100, 0.7, 1, 0.5, 1)
    end
end)

Isaac.DebugString("Room Morph loaded!")
