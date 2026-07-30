-- =============================================================================
--  ImpFlameTrail - The Binding of Isaac: Repentance
--  Imp leaves a trail of red creep (damaging fire) behind it as it moves
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ImpFlameTrail", 1)
local IMP_TYPE = 23 -- EntityType.ENTITY_GLOBIN (Imp variant check via variant)
local CREEP_INTERVAL = 15 -- frames between creep drops
local creepTimers = {}
local lastPositions = {}

local function isImpType(entity)
    -- Imps: regular imp, bomb imp, etc. Check based on common imp behavior
    local t = entity.Type
    return t == 23 -- GLOBIN type covers imps
end

local function onNPCUpdate(_, entity)
    if not isImpType(entity) or not entity:Exists() then
        return
    end

    local idx = entity.Index
    if not creepTimers[idx] then
        creepTimers[idx] = 0
        lastPositions[idx] = entity.Position
    end

    creepTimers[idx] = creepTimers[idx] - 1
    if creepTimers[idx] <= 0 then
        creepTimers[idx] = CREEP_INTERVAL

        local pos = entity.Position
        local lastPos = lastPositions[idx]
        local moved = pos:Distance(lastPos)

        if moved > 3 then
            -- Spawn red creep at current position
            local room = Game():GetRoom()
            if room then
                local gridPos = room:GetGridIndex(pos)
                local grid = room:GetGridEntity(gridPos)
                if not grid then
                    Isaac.GridSpawn(GridEntityType.GRID_RED, 0, pos, false)
                end
            end
        end
        lastPositions[idx] = pos
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("ImpFlameTrail loaded!")
