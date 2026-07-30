-- =============================================================================
--  GridEntityDetector — The Binding of Isaac: Repentance
--  Rocks, spikes, and TNT near player glow with outline indicator.
--  Version: 1.0   | Official API only
-- =============================================================================

local mod = RegisterMod("GridEntityDetector", 1)
local game = Game()
local DETECT_RANGE = 80 -- pixels

function mod:onPostRender()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    local room = game:GetRoom()
    if not room then return end

    local playerPos = player.Position
    local numGridEntities = room:GetGridSize()

    for i = 0, numGridEntities - 1 do
        local gridEnt = room:GetGridEntity(i)
        if gridEnt then
            local gridType = gridEnt:GetType()
            -- Skip empty or walls
            if gridType == GridEntityType.GRID_ROCK or
               gridType == GridEntityType.GRID_ROCKB or
               gridType == GridEntityType.GRID_ROCK_ALT or
               gridType == GridEntityType.GRID_ROCKTNT or
               gridType == GridEntityType.GRID_SPIKES or
               gridType == GridEntityType.GRID_POOP or
               gridType == GridEntityType.GRID_TNT then

                local gridPos = gridEnt.Position
                local dx = gridPos.X - playerPos.X
                local dy = gridPos.Y - playerPos.Y
                local dist = math.sqrt(dx * dx + dy * dy)

                if dist <= DETECT_RANGE then
                    -- Draw a simple indicator circle around the grid entity
                    local alpha = 1 - (dist / DETECT_RANGE) -- closer = brighter
                    Isaac.RenderText("*", gridPos.X, gridPos.Y, 1.5, 1.5, 1, 1, 0, alpha)
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("GridEntityDetector loaded!")
