-- =============================================================================
--  HiveFactory — The Binding of Isaac: Repentance
--  Hives (Type=9) spawn flies 2x faster and flies are champion-colored.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("HiveFactory", 1)

local SPAWN_SPEED_MULTIPLIER = 2
local hiveTimers = {}

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= 9 then return end

    local idx = npc.Index
    if not hiveTimers[idx] then
        hiveTimers[idx] = { lastState = npc.State }
        return
    end

    -- Detect state change (hive opening to spawn), speed up the cycle
    if npc.State ~= hiveTimers[idx].lastState then
        npc.StateFrame = npc.StateFrame * SPAWN_SPEED_MULTIPLIER
    end

    -- Accelerate the internal timer for fly spawning
    if npc.StateFrame > 0 then
        npc.StateFrame = math.floor(npc.StateFrame * SPAWN_SPEED_MULTIPLIER)
    end

    hiveTimers[idx].lastState = npc.State
end

function mod:onEntitySpawn(_, entity)
    -- Detect spawned flies and make them champion-colored
    if not entity:IsVulnerableEnemy() then return end
    local flyTypes = { 13, 18, 27, 47 } -- common fly entity types
    for _, flyType in ipairs(flyTypes) do
        if entity.Type == flyType then
            entity:AddEntityFlags(EntityFlag.FLAG_CHAMPION)
            entity:SetColor(Color(1, 0.2, 0.2, 1), 0, 1)
            break
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.onEntitySpawn)
Isaac.DebugString("HiveFactory loaded!")
