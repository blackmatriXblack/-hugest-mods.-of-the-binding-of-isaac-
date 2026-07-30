-- =============================================================================
--  DrownedHiveWet — The Binding of Isaac: Repentance
--  Drowned Hives (Type=9, Variant=1) spawn Drowned Chargers instead of flies.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DrownedHiveWet", 1)

local DROWNED_CHARGER_TYPE = 239
local SPAWN_INTERVAL = 60
local hiveTimers = {}
local flyTypeList = { 13, 18, 27, 47 }

local function isFlyEntity(entity)
    for _, ft in ipairs(flyTypeList) do
        if entity.Type == ft then return true end
    end
    return false
end

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= 9 or npc.Variant ~= 1 then return end

    local idx = npc.Index
    if not hiveTimers[idx] then
        hiveTimers[idx] = 0
    end

    hiveTimers[idx] = hiveTimers[idx] + 1

    if hiveTimers[idx] >= SPAWN_INTERVAL then
        hiveTimers[idx] = 0
        local player = Isaac.GetPlayer(0)
        local dir = (player.Position - npc.Position):Normalized()
        local charger = Isaac.Spawn(
            DROWNED_CHARGER_TYPE, 0, 0,
            npc.Position, dir * 2, npc
        )
        if charger then
            charger:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        end
    end

    -- Remove any default flies that spawned near the hive
    local nearbyEntities = Isaac.GetRoomEntities()
    for _, ent in ipairs(nearbyEntities) do
        if isFlyEntity(ent) and ent.FrameCount <= 1 then
            if ent.Position:Distance(npc.Position) < 80 then
                ent:Remove()
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("DrownedHiveWet loaded!")
