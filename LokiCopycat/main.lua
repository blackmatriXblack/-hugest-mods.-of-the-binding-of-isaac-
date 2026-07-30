-- =============================================================================
--  LokiCopycat — The Binding of Isaac: Repentance
--  Loki (Type=26) creates mirror images of himself every 15 seconds
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("LokiCopycat", 1)

local LOKI_TYPE = EntityType.ENTITY_LOKI
local COPY_INTERVAL = 450 -- 15 seconds at 30 FPS
local COPY_COUNT = 2

local copyTimer = {}

function mod:onNPCUpdate(npc)
    if npc.Type ~= LOKI_TYPE or npc.Variant ~= 0 then
        return
    end

    local idx = GetPtrHash(npc)
    if not copyTimer[idx] then
        copyTimer[idx] = 0
    end

    copyTimer[idx] = copyTimer[idx] + 1

    if copyTimer[idx] >= COPY_INTERVAL then
        copyTimer[idx] = 0

        for i = 1, COPY_COUNT do
            local angle = (i - 1) * (math.pi * 2 / COPY_COUNT) + math.random() * 0.5
            local offsetX = math.cos(angle) * 80
            local offsetY = math.sin(angle) * 80
            local spawnPos = Vector(npc.Position.X + offsetX, npc.Position.Y + offsetY)

            local clone = Isaac.Spawn(LOKI_TYPE, npc.Variant, npc.SubType, spawnPos, Vector.Zero, npc)
            if clone then
                clone:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
                -- mirror clone won't attack; pure visual/distraction
                clone.Color = Color(1, 1, 1, 0.5, 0, 0, 0) -- semi-transparent
            end
        end
    end
end

function mod:onNPCDeath(npc)
    local idx = GetPtrHash(npc)
    copyTimer[idx] = nil
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.onNPCDeath)
Isaac.DebugString("LokiCopycat loaded!")
