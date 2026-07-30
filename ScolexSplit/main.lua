-- =============================================================================
--  ScolexSplit — The Binding of Isaac: Repentance
--  Scolex (Type=39.0) tail segment acts independently as a separate enemy
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ScolexSplit", 1)

local SCOLEX_TYPE = EntityType.ENTITY_SCOLEX
local SCOLEX_VARIANT = 0
local SCOLEX_TAIL_TYPE = EntityType.ENTITY_SCOLEX -- variant 1 = tail

local processedScolex = {}

function mod:onPostEntitySpawn(entity)
    if entity.Type ~= SCOLEX_TYPE or entity.Variant ~= SCOLEX_VARIANT then
        return
    end

    local idx = GetPtrHash(entity)
    if processedScolex[idx] then
        return
    end
    processedScolex[idx] = true

    -- Spawn an independent tail enemy slightly behind the Scolex
    local tailPos = Vector(entity.Position.X, entity.Position.Y + 40)
    local tail = Isaac.Spawn(SCOLEX_TAIL_TYPE, 1, 0, tailPos, Vector.Zero, entity)

    if tail then
        -- Tail has half the main body HP and can move/attack independently
        tail.HitPoints = entity.HitPoints / 2
        tail:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
        tail:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
        -- Make tail aggressive toward player like a separate enemy
        tail:GetData().independent = true
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onPostEntitySpawn)
Isaac.DebugString("ScolexSplit loaded!")
