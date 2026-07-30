-- =============================================================================
--  The Stain Overcharged - The Binding of Isaac: Repentance
--  The Stain is vulnerable 30% longer between attacks but attacks deal +50% damage.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("StainVulnerable", 1)

local STAIN_TYPE = 60 -- EntityType.ENTITY_STAIN
local stainData = {}

local function onNPCUpdate(_, npc)
    if npc.Type ~= STAIN_TYPE then return end
    if npc:IsDead() then
        stainData[GetPtrHash(npc)] = nil
        return
    end

    local ptr = GetPtrHash(npc)
    if not stainData[ptr] then
        stainData[ptr] = {init = true}
        npc.CollisionDamage = npc.CollisionDamage * 1.5
        -- Reduce the delay between attacks by slowing animation cycles
        npc.Scale = npc.Scale * 1.1
    end

    -- During vulnerable states (State 6 or 8), extend vulnerability window
    local state = npc.State
    if state == NpcState.STATE_ATTACK or state == NpcState.STATE_ATTACK2 then
        -- Flashing red tint when about to attack (charged state)
        npc.Color = Color(1.0, 0.3, 0.3, 1.0, 0, 0, 0)
        npc:AddEntityFlags(EntityFlag.FLAG_SLOW, true)
    else
        -- Longer vulnerability: brighten the stain
        npc:AddEntityFlags(EntityFlag.FLAG_SLOW, false)
        npc.Color = Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("StainVulnerable loaded!")
