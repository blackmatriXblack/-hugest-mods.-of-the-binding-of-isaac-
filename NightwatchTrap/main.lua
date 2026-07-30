-- =============================================================================
--  Nightwatch Shadow Traps - The Binding of Isaac: Repentance
--  Nightwatch places invisible shadow traps that fear the player when stepped on.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("NightwatchTrap", 1)

local NIGHTWATCH_TYPE = 803  -- Nightwatch entity type (Repentance)
local TRAP_MAX = 6
local TRAP_RADIUS = 28       -- Player trigger radius
local TRAP_INTERVAL = 120    -- Frames between trap placements

local trapData = {}          -- {pos, roomIndex, placedFrame, triggered}
local lastTrapPlace = 0

local function placeTrap(pos, roomIdx, frame)
    table.insert(trapData, {
        pos = pos,
        roomIndex = roomIdx,
        placedFrame = frame,
        triggered = false
    })
    -- Keep max traps
    while #trapData > TRAP_MAX do
        table.remove(trapData, 1)
    end
end

local function distance(a, b)
    return math.sqrt((a.X - b.X) ^ 2 + (a.Y - b.Y) ^ 2)
end

local function onNPCUpdate(_, npc)
    if npc.Type ~= NIGHTWATCH_TYPE then return end
    if npc:IsDead() then return end

    local currentFrame = Game():GetFrameCount()
    local room = Game():GetRoom()
    local roomIdx = room:GetRoomDesc().SafeGridIndex

    -- Place traps periodically when Nightwatch is active
    if npc.State == NpcState.STATE_ATTACK2 or npc.State == NpcState.STATE_SPECIAL then
        if currentFrame - lastTrapPlace >= TRAP_INTERVAL then
            lastTrapPlace = currentFrame
            local trapPos = npc.Position + Vector(math.random(-60, 60), math.random(-60, 60))
            placeTrap(trapPos, roomIdx, currentFrame)
        end
    end

    -- Check player proximity to traps
    local player = Isaac.GetPlayer(0)
    if player then
        for i = #trapData, 1, -1 do
            local trap = trapData[i]
            if trap.roomIndex == roomIdx and not trap.triggered then
                if distance(player.Position, trap.pos) <= TRAP_RADIUS then
                    trap.triggered = true
                    -- Apply fear effect: add Fear costume + temporary speed burst away
                    player:AddFear(EntityRef(player), 90)
                    -- Push player away from trap center
                    local pushDir = (player.Position - trap.pos):Normalized()
                    player.Velocity = pushDir * 6.0
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("NightwatchTrap loaded!")
