-- =============================================================================
--  PerformanceMonitor - The Binding of Isaac: Repentance
--  Show FPS, entity count, memory usage overlay — toggle with F12
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PerformanceMonitor", 1)
local showMonitor = false
local frameCount = 0
local fpsTimer = 0
local currentFPS = 0
local entityCount = 0
local roomEntityCount = 0
local gridEntityCount = 0
local pickupCount = 0
local tearCount = 0
local bossCount = 0
local minFPS = 999
local maxFPS = 0
local avgFPS = 0
local totalFramesRecorded = 0
local fpsSum = 0

function mod:onUpdate()
    -- FPS calculation
    frameCount = frameCount + 1
    fpsTimer = fpsTimer + 1

    if fpsTimer >= 30 then
        currentFPS = frameCount
        frameCount = 0
        fpsTimer = 0

        -- Track min/max/avg
        if currentFPS > 0 then
            if currentFPS < minFPS then minFPS = currentFPS end
            if currentFPS > maxFPS then maxFPS = currentFPS end
            totalFramesRecorded = totalFramesRecorded + 1
            fpsSum = fpsSum + currentFPS
            avgFPS = fpsSum / totalFramesRecorded
        end
    end

    -- Toggle
    if Input.IsButtonPressed(Keyboard.KEY_F12, 0) then
        showMonitor = not showMonitor
        Isaac.DebugString("PerformanceMonitor: " .. (showMonitor and "ON" or "OFF"))
    end
end

function mod:onRender()
    if not showMonitor then return end

    -- Collect stats
    local entities = Isaac.GetRoomEntities()
    roomEntityCount = #entities
    entityCount = 0
    pickupCount = 0
    tearCount = 0
    bossCount = 0

    for _, entity in ipairs(entities) do
        if entity:IsActiveEnemy() then
            entityCount = entityCount + 1
            if entity:IsBoss() then bossCount = bossCount + 1 end
        elseif entity.Type == EntityType.ENTITY_PICKUP then
            pickupCount = pickupCount + 1
        elseif entity.Type == EntityType.ENTITY_TEAR then
            tearCount = tearCount + 1
        end
    end

    -- Grid entity count
    local room = Game():GetRoom()
    gridEntityCount = 0
    if room then
        for i = 0, room:GetGridSize() - 1 do
            if room:GetGridEntity(i) then
                gridEntityCount = gridEntityCount + 1
            end
        end
    end

    -- Memory approximation (Lua garbage)
    local memKB = math.floor(collectgarbage("count"))

    -- Render overlay
    local font = Font()
    local x = Isaac.GetScreenWidth() - 220
    local y = 5
    local lineH = 13
    local alpha = 0.88

    -- FPS with color coding
    local fpsColor
    if currentFPS >= 60 then
        fpsColor = KColor(0.3, 1, 0.3, alpha) -- Green: 60+ FPS
    elseif currentFPS >= 30 then
        fpsColor = KColor(1, 1, 0, alpha)     -- Yellow: 30-59 FPS
    else
        fpsColor = KColor(1, 0.3, 0.3, alpha) -- Red: below 30 FPS
    end

    font:DrawString("=== PERFORMANCE MONITOR ===", x, y, KColor(0, 1, 1, 1), 0, false)
    y = y + 16

    font:DrawString(string.format("FPS: %d  |  Min: %d  |  Max: %d  |  Avg: %d",
        currentFPS, minFPS, maxFPS, math.floor(avgFPS)), x, y, fpsColor, 0, false)
    y = y + lineH

    font:DrawString("------------------------------------", x, y, KColor(0.4, 0.4, 0.4, alpha), 0, false)
    y = y + lineH + 2

    font:DrawString(string.format("Total Entities: %d", roomEntityCount), x, y, KColor(1, 1, 1, alpha), 0, false)
    y = y + lineH
    font:DrawString(string.format("  - Enemies: %d (Bosses: %d)", entityCount, bossCount),
        x + 5, y, KColor(1, 0.7, 0.7, alpha), 0, false)
    y = y + lineH
    font:DrawString(string.format("  - Pickups: %d", pickupCount),
        x + 5, y, KColor(1, 1, 0.7, alpha), 0, false)
    y = y + lineH
    font:DrawString(string.format("  - Tears/Projectiles: %d", tearCount),
        x + 5, y, KColor(0.7, 1, 1, alpha), 0, false)
    y = y + lineH
    font:DrawString(string.format("Grid Entities: %d", gridEntityCount),
        x, y, KColor(1, 1, 1, alpha), 0, false)
    y = y + lineH + 4

    font:DrawString("------------------------------------", x, y, KColor(0.4, 0.4, 0.4, alpha), 0, false)
    y = y + lineH + 2

    font:DrawString(string.format("Lua Memory: %d KB", memKB), x, y, KColor(1, 1, 0.7, alpha), 0, false)
    y = y + lineH

    -- Performance grade
    local grade = "A"
    if currentFPS < 30 then grade = "D"
    elseif currentFPS < 45 then grade = "C"
    elseif currentFPS < 55 then grade = "B"
    end
    local gradeColor
    if grade == "A" then gradeColor = KColor(0.3, 1, 0.3, 1)
    elseif grade == "B" then gradeColor = KColor(1, 1, 0, 1)
    elseif grade == "C" then gradeColor = KColor(1, 0.6, 0, 1)
    else gradeColor = KColor(1, 0.2, 0.2, 1)
    end
    font:DrawString("Performance Grade: " .. grade, x, y, gradeColor, 0, false)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("PerformanceMonitor loaded!")
