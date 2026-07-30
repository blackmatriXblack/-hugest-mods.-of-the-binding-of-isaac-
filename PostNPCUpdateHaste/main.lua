-- =============================================================================
--  PostNPCUpdateHaste — The Binding of Isaac: Repentance
--  MC_POST_NPC_UPDATE: Enemies gain 5% speed per minute alive (cap at 200%).
--  Track spawn time per entity.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PostNPCUpdateHaste", 1)

local SPAWN_TIME = {}           -- Track spawn time per entity (in frames)
local SPEED_SCALE_PER_SEC = 0.05 / 60 -- 5% per minute, per frame
local MAX_SPEED_SCALE = 2.0

function mod:onNPCInit(npc)
    local idx = GetPtrHash(npc)
    SPAWN_TIME[idx] = Isaac.GetFrameCount()
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_INIT, mod.onNPCInit)

function mod:onPostNPCUpdate(npc)
    if not npc:Exists() or npc:IsDead() then return end

    local idx = GetPtrHash(npc)
    local spawnFrame = SPAWN_TIME[idx]
    if not spawnFrame then return end

    local currentFrame = Isaac.GetFrameCount()
    local elapsed = currentFrame - spawnFrame
    local speedMult = 1.0 + elapsed * SPEED_SCALE_PER_SEC

    if speedMult > MAX_SPEED_SCALE then
        speedMult = MAX_SPEED_SCALE
    end

    -- Apply speed multiplier via Pathfinder scale
    local pf = npc.Pathfinder
    if pf then
        pf:SetSpeedModifier(speedMult)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onPostNPCUpdate)

Isaac.DebugString("PostNPCUpdateHaste loaded!")
