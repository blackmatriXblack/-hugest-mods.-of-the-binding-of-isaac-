-- =============================================================================
--  BabyLongLegsStomp — The Binding of Isaac: Repentance
--  Baby Long Legs (Type=206) create rock waves on stomp.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BabyLongLegsStomp", 1)
local stompTracked = {}

function mod:onNPCUpdate(npc)
    if npc.Type ~= 206 then return end

    local idx = GetPtrHash(npc)
    local prevY = stompTracked[idx]

    if prevY and prevY > npc.Position.Y + 5 and npc.Velocity.Y > 0 then
        local pos = npc.Position
        local offsets = {
            Vector(0, 0), Vector(80, 0), Vector(-80, 0),
            Vector(0, 80), Vector(0, -80),
            Vector(60, 60), Vector(-60, 60), Vector(60, -60), Vector(-60, -60)
        }
        for _, off in ipairs(offsets) do
            local rockPos = pos + off
            if not Isaac.GetRoom():IsPositionInRoom(rockPos, 0) then
                local gridIdx = Isaac.GetRoom():GetGridIndex(rockPos)
                local grid = Isaac.GetRoom():GetGridEntity(gridIdx)
                if grid and grid:GetType() == GridEntityType.GRID_ROCK then
                    grid:Destroy(false)
                end
                Isaac.GetRoom():SpawnGridEntity(gridIdx, GridEntityType.GRID_ROCK, 0, 0)
            end
        end
    end

    stompTracked[idx] = npc.Position.Y
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
Isaac.DebugString("BabyLongLegsStomp loaded!")
