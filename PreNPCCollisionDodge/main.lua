-- =============================================================================
--  PreNPCCollisionDodge — The Binding of Isaac: Repentance
--  MC_PRE_NPC_COLLISION: 15% chance enemies dodge player tears (become ghost briefly).
--  Uses EntityCollisionClass.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PreNPCCollisionDodge", 1)

-- Per-entity ghost frame timer
local GHOST_DURATION = 30 -- 1 second at 30fps
local GHOST_END_FRAME = {}
local GHOST_ORIG_CLASS = {}

function mod:onPreNPCCollision(npc, other, low)
    -- Only handle player tears hitting enemies
    if not npc:Exists() or npc:IsDead() then return nil end
    if not other:Exists() then return nil end

    local idx = GetPtrHash(npc)

    -- Check if entity is currently ghosting
    if GHOST_END_FRAME[idx] then
        if Isaac.GetFrameCount() < GHOST_END_FRAME[idx] then
            return false -- Block collision while ghosting
        else
            -- Restore original collision class
            npc.EntityCollisionClass = GHOST_ORIG_CLASS[idx] or EntityCollisionClass.ENTCOLL_ALL
            GHOST_END_FRAME[idx] = nil
            GHOST_ORIG_CLASS[idx] = nil
        end
    end

    -- 15% chance to dodge
    if math.random(1, 100) <= 15 then
        GHOST_ORIG_CLASS[idx] = npc.EntityCollisionClass
        GHOST_END_FRAME[idx] = Isaac.GetFrameCount() + GHOST_DURATION
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE
        return false -- Collision is cancelled
    end

    return nil -- Default behavior
end
mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.onPreNPCCollision)

Isaac.DebugString("PreNPCCollisionDodge loaded!")
