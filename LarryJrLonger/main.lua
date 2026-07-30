-- =============================================================================
--  LarryJrLonger — The Binding of Isaac: Repentance
--  Larry Jr (Type=19) gets 5 extra segments (longer worm)
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("LarryJrLonger", 1)

local LARRY_TYPE = EntityType.ENTITY_LARRYJR
local EXTRA_SEGMENTS = 5

local hasExtended = {}

function mod:onPostEntitySpawn(entity)
    if entity.Type ~= LARRY_TYPE then
        return
    end

    local idx = GetPtrHash(entity)
    if hasExtended[idx] then
        return
    end
    hasExtended[idx] = true

    -- Grow the worm by an additional amount of segments
    entity:ToNPC():Grow(EXTRA_SEGMENTS)
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onPostEntitySpawn)
Isaac.DebugString("LarryJrLonger loaded!")
