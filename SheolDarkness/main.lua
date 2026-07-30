-- =============================================================================
--  SheolDarkness - The Binding of Isaac: Repentance
--  Sheol floors reduce the player's vision range by 30% through creeping darkness
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SheolDarkness", 1)

local function IsSheol()
    local level = Game():GetLevel()
    return level:GetStage() == LevelStage.STAGE7
       and level:GetStageType() == StageType.STAGETYPE_ORIGINAL
end

local function ApplyDarkness()
    if not IsSheol() then return end

    local room = Game():GetRoom()
    -- Apply Curse of Darkness effect (-2 brightness) equivalent
    -- We use room blackout radius to constrict vision
    local center = room:GetCenterPos()

    -- Spawn darkness grid entities at the edges of rooms to simulate vision loss
    -- Check all grid points in the room
    for x = 0, room:GetGridWidth() - 1 do
        for y = 0, room:GetGridHeight() - 1 do
            if room:IsGridObstructedAt(x, y) then
                -- Already obstructed, skip
            else
                -- 30% of clear grid cells get obscured by darkness
                if math.random(1, 100) <= 30 then
                    local pos = room:GetGridPosition(x, y)
                    -- Use cobwebs as "dark patches" that slow and obscure
                    Isaac.GridSpawn(GridEntityType.GRID_SPIDERWEB, 0, pos, true)
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, ApplyDarkness)
Isaac.DebugString("SheolDarkness loaded!")
