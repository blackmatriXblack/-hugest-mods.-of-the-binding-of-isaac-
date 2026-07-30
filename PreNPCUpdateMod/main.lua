-- =============================================================================
--  PreNPCUpdateMod — The Binding of Isaac: Repentance
--  MC_PRE_NPC_UPDATE: All enemies randomly change direction every 3 seconds.
--  Return false to cancel default update and apply custom AI.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PreNPCUpdateMod", 1)

local DIRECTION_UP = Vector(0, -1)
local DIRECTION_DOWN = Vector(0, 1)
local DIRECTION_LEFT = Vector(-1, 0)
local DIRECTION_RIGHT = Vector(1, 0)
local DIRECTIONS = {DIRECTION_UP, DIRECTION_DOWN, DIRECTION_LEFT, DIRECTION_RIGHT}
local UPDATE_INTERVAL = 90 -- 3 seconds at 30fps (3 * 30 = 90)
local LAST_DIR_CHANGE = {}

function mod:onPreNPCUpdate(npc)
    local idx = GetPtrHash(npc)
    LAST_DIR_CHANGE[idx] = LAST_DIR_CHANGE[idx] or 0
    LAST_DIR_CHANGE[idx] = LAST_DIR_CHANGE[idx] + 1

    if LAST_DIR_CHANGE[idx] >= UPDATE_INTERVAL then
        LAST_DIR_CHANGE[idx] = 0
        local dir = DIRECTIONS[math.random(1, 4)]
        npc.Velocity = dir * 3
        npc:Update()
        return false -- Cancel default update
    end
    return true
end

mod:AddCallback(ModCallbacks.MC_PRE_NPC_UPDATE, mod.onPreNPCUpdate)
Isaac.DebugString("PreNPCUpdateMod loaded!")
