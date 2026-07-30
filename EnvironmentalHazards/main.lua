-- ==========================================================================
--  Environmental Hazards - The Binding of Isaac: Repentance
--  50% of rooms spawn extra spikes, fires, and creep on entry
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("EnvironmentalHazards", 1)
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    -- 50% chance to add hazards
    if math.random() > 0.5 then return end

    local room = game:GetRoom()
    local roomCenter = room:GetCenterPos()
    local roomShape = room:GetRoomShape()

    -- Spawn fire hazards
    for i = 1, math.random(6, 12) do
        local pos = Vector(
            roomCenter.X + math.random(-200, 200),
            roomCenter.Y + math.random(-120, 120)
        )
        -- Check if position is valid (not inside a wall)
        if room:IsPositionInRoom(pos, 0) then
            local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT,
                EffectVariant.HOT_BOMB_FIRE, 0,
                pos, Vector.Zero, nil)
            if fire then
                -- Fire persists
                fire:AddEntityFlags(EntityFlag.FLAG_PERSISTENT)
            end
        end
    end

    -- Spawn spike hazards
    local gridSize = room:GetGridSize()
    for i = 1, math.random(4, 8) do
        local gridX = math.random(2, gridSize - 2)
        local gridY = math.random(2, gridSize - 2)
        
        local gridIdx = room:GetGridIndex(Vector(gridX * 40, gridY * 40))
        local gridEntity = room:GetGridEntity(gridIdx)
        
        -- Set spikes where there's empty grid space
        if gridEntity and gridEntity:GetType() == GridEntityType.GRID_NOTHING then
            room:SpawnGridEntity(gridIdx, GridEntityType.GRID_SPIKES,
                0, 0, -1)
        end
    end

    Isaac.DebugString("Environmental hazards added to this room!")
end)

Isaac.DebugString("Environmental Hazards loaded!")
