-- ==========================================================================
--  SecretRoomHum - The Binding of Isaac: Repentance
--  Screen edge hums and vibrates slightly when near a secret room wall!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SecretRoomHum", 1)
local humIntensity = 0
local PROXIMITY_RANGE = 80

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    local pos = player.Position
    local room = Game():GetRoom()
    local closestDist = 9999

    for x = 0, room:GetGridWidth() - 1 do
        for y = 0, room:GetGridHeight() - 1 do
            local grid = room:GetGridEntity(x, y)
            if grid and grid:GetType() == GridEntityType.GRID_WALL then
                local gridPos = room:GetGridPosition(x, y)
                local adjacentRooms = {false, false, false, false}
                local dist = pos:Distance(gridPos)
                if dist < closestDist then
                    closestDist = dist
                end
            end
        end
    end

    local humTraps = room:GetGridEntities(GridEntityType.GRID_WALL)
    for _, grid in pairs(humTraps) do
        local gridPos = grid.Position
        local dist = pos:Distance(gridPos)
        if dist < PROXIMITY_RANGE then
            humIntensity = 1 - dist / PROXIMITY_RANGE
            break
        end
    end

    if humIntensity > 0.1 then
        local shake = humIntensity * 2
        Game():ScreenShake(shake, 1)

        local w, h = Isaac.GetScreenWidth(), Isaac.GetScreenHeight()
        local alpha = humIntensity * 0.3
        local r, g, b = 0.6 + math.random() * 0.4, 0.5 + math.random() * 0.3, 0
    end

    humIntensity = humIntensity * 0.9
end)

Isaac.DebugString("SecretRoomHum loaded! Can you feel the secrets?")
