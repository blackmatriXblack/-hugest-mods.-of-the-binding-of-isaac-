-- =============================================================================
--  PokySpikeTrap - The Binding of Isaac: Repentance
--  Poky leaves a spike trap behind every 5 seconds that damages player on touch
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PokySpikeTrap", 1)
local POKY_TYPE = 212 -- EntityType.ENTITY_POKY
local TRAP_INTERVAL = 150 -- 5 seconds
local TRAP_LIFETIME = 600  -- 20 seconds

local trapData = {} -- {gridEntity, timer}

local function onNPCUpdate(_, entity)
    if entity.Type ~= POKY_TYPE or not entity:Exists() then
        return
    end

    if not entity.I1 then entity.I1 = 0 end
    entity.I1 = entity.I1 + 1

    if entity.I1 >= TRAP_INTERVAL then
        entity.I1 = 0

        local pos = entity.Position
        local room = Game():GetRoom()
        if not room then return end

        -- Spawn a spike trap at current position
        local gridIdx = room:GetGridIndex(pos)
        local existing = room:GetGridEntity(gridIdx)
        if not existing then
            Isaac.GridSpawn(GridEntityType.GRID_SPIKES, 0, pos, false)
            local grid = room:GetGridEntity(gridIdx)
            if grid then
                local idx = grid:GetSaveState()
                trapData[#trapData + 1] = {
                    grid = grid,
                    timer = TRAP_LIFETIME,
                    index = gridIdx
                }
            end
        end
    end

    -- Clean up expired traps
    for i = #trapData, 1, -1 do
        local t = trapData[i]
        t.timer = t.timer - 1
        if t.timer <= 0 then
            local room = Game():GetRoom()
            if room then
                local grid = room:GetGridEntity(t.index)
                if grid then
                    grid:Destroy()
                end
            end
            table.remove(trapData, i)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("PokySpikeTrap loaded!")
