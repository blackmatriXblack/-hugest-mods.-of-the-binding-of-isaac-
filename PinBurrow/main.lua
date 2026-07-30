-- =============================================================================
--  PinBurrow — The Binding of Isaac: Repentance
--  Pin (Type=22) spawns 4 Dips each time he burrows
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PinBurrow", 1)

local PIN_TYPE = EntityType.ENTITY_PIN
local DIP_TYPE = EntityType.ENTITY_DIP
local DIP_VARIANT = 0
local DIP_COUNT = 4

-- Pin burrow states: State 5 or 6 are typically burrowing/underground states
local STATE_BURROW_START = 5
local STATE_BURROW_EMERGE = 6

local prevState = {}

function mod:onNPCUpdate(npc)
    if npc.Type ~= PIN_TYPE or npc.Variant ~= 0 then
        return
    end

    local idx = GetPtrHash(npc)
    local state = npc.State
    local lastState = prevState[idx] or 0

    -- Detect transition into burrow state
    if state == STATE_BURROW_START and lastState ~= STATE_BURROW_START then
        for i = 1, DIP_COUNT do
            local angle = (i - 1) * (math.pi * 2 / DIP_COUNT)
            local offsetX = math.cos(angle) * 40
            local offsetY = math.sin(angle) * 40
            local spawnPos = Vector(npc.Position.X + offsetX, npc.Position.Y + offsetY)
            Isaac.Spawn(DIP_TYPE, DIP_VARIANT, 0, spawnPos, Vector.Zero, npc)
        end
    end

    prevState[idx] = state
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
Isaac.DebugString("PinBurrow loaded!")
