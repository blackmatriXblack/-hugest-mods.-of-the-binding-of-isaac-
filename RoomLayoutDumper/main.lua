-- =============================================================================
--  RoomLayoutDumper - The Binding of Isaac: Repentance
--  Press F6 to dump current room layout data to log file
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RoomLayoutDumper", 1)
local dumpCooldown = 0

local function GetGridEntityTypeName(gridType)
    local names = {
        [0] = "NONE", [1000] = "ROCK", [1001] = "ROCK_BOMB",
        [1010] = "ROCK_TINTED", [1300] = "ROCK_ALT",
        [1494] = "ROCK_PILLAR", [1495] = "ROCK_SPIKED",
        [1497] = "ROCK_FOOLS_GOLD", [1900] = "ROCK_BLOCK",
        [1901] = "ROCK_HIVE", [2000] = "PIT", [3000] = "SPIKES",
        [4000] = "POOP", [5000] = "FIREPLACE", [6000] = "DOOR",
        [9000] = "LOCK", [10000] = "PRESSURE_PLATE", [10002] = "REWARD_PLATE",
        [12000] = "TNT", [15000] = "TELEPORTER",
    }
    return names[gridType] or ("GRID_" .. tostring(gridType))
end

function mod:onUpdate()
    if Input.IsButtonPressed(Keyboard.KEY_F6, 0) and dumpCooldown <= 0 then
        dumpCooldown = 30

        local game = Game()
        local level = game:GetLevel()
        local room = game:GetRoom()

        local dumpLines = {}
        table.insert(dumpLines, "====== ROOM LAYOUT DUMP ======")
        table.insert(dumpLines, "Timestamp: " .. os.date("%Y-%m-%d %H:%M:%S"))
        table.insert(dumpLines, "Stage: " .. level:GetStage() .. " Type: " .. level:GetStageType())
        table.insert(dumpLines, "Room Index: " .. level:GetCurrentRoomDesc().SafeGridIndex)
        table.insert(dumpLines, "Room Type: " .. room:GetType())
        table.insert(dumpLines, "Room Shape: " .. room:GetRoomShape())
        table.insert(dumpLines, "Grid Size: " .. room:GetGridSize())
        table.insert(dumpLines, "Room Dimensions: " .. room:GetGridWidth() .. "x" .. room:GetGridHeight())
        table.insert(dumpLines, "Clear: " .. tostring(room:IsClear()) .. "  First Visit: " .. tostring(room:IsFirstVisit()))
        table.insert(dumpLines, "")

        -- Dump grid entities
        table.insert(dumpLines, "--- GRID ENTITIES ---")
        local gridCount = 0
        for i = 0, room:GetGridSize() - 1 do
            local ge = room:GetGridEntity(i)
            if ge then
                gridCount = gridCount + 1
                local gridPos = room:GetGridPosition(i)
                local gridType = ge:GetType()
                local variant = ge:GetVariant()
                local state = ge.State
                local descStr = string.format("  [%d] @ grid(%d,%d) Type:%s(%d) Variant:%d State:%d",
                    i, gridPos.X, gridPos.Y, GetGridEntityTypeName(gridType), gridType, variant, state)
                table.insert(dumpLines, descStr)
            end
        end
        table.insert(dumpLines, "Total Grid Entities: " .. gridCount)
        table.insert(dumpLines, "")

        -- Dump room entities (monsters, pickups)
        table.insert(dumpLines, "--- ROOM ENTITIES ---")
        local entities = Isaac.GetRoomEntities()
        local entityCount = 0
        for _, entity in ipairs(entities) do
            if entity:IsActiveEnemy() or entity:IsVulnerableEnemy() or entity.Type > 3 then
                entityCount = entityCount + 1
                local e = entity
                local descStr = string.format("  Type:%d Variant:%d SubType:%d Pos:(%d,%d) HP:%.1f",
                    e.Type, e.Variant, e.SubType,
                    math.floor(e.Position.X), math.floor(e.Position.Y),
                    e.HitPoints)
                table.insert(dumpLines, descStr)
            end
        end
        table.insert(dumpLines, "Total Entities: " .. entityCount)
        table.insert(dumpLines, "")

        -- Dump pickups
        table.insert(dumpLines, "--- PICKUPS ---")
        local pickupCount = 0
        for _, entity in ipairs(entities) do
            if entity.Type == EntityType.ENTITY_PICKUP then
                pickupCount = pickupCount + 1
                local e = entity
                local descStr = string.format("  Variant:%d SubType:%d Pos:(%d,%d) Price:%d",
                    e.Variant, e.SubType,
                    math.floor(e.Position.X), math.floor(e.Position.Y),
                    e.Price)
                table.insert(dumpLines, descStr)
            end
        end
        table.insert(dumpLines, "Total Pickups: " .. pickupCount)
        table.insert(dumpLines, "====== END DUMP ======")

        -- Write to log file
        local logPath = Isaac.GetSavePath() .. "/room_layout_dump.log"
        local file = io.open(logPath, "a")
        if file then
            for _, line in ipairs(dumpLines) do
                file:write(line .. "\n")
            end
            file:close()
            Isaac.DebugString("RoomLayoutDumper: Layout dumped to " .. logPath)
        else
            Isaac.DebugString("RoomLayoutDumper: Failed to open log file!")
        end

        -- Also print to debug console
        for _, line in ipairs(dumpLines) do
            Isaac.DebugString(line)
        end
    end

    if dumpCooldown > 0 then
        dumpCooldown = dumpCooldown - 1
    end
end

function mod:onRender()
    if dumpCooldown > 0 then
        local font = Font()
        font:DrawString("Room layout dumped! Check log file.",
            Isaac.GetScreenWidth() * 0.3, Isaac.GetScreenHeight() * 0.45,
            KColor(0.3, 1, 0.3, 1), 0, false)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("RoomLayoutDumper loaded!")
