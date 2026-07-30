-- =============================================================================
--  Cursed Globin Overgrowth - The Binding of Isaac: Repentance
--  Cursed Globin revives with +50% max HP, making it far harder to finish off.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CursedGlobinRevive", 1)

-- Cursed Globin: Repentance variant, can be tracked via Globin type + subtype
local CURSED_GLOBIN_TYPE = 17  -- Base Globin type (ENTITY_GLOBIN)
local CURSED_SUBTYPE = 3       -- Cursed variant subtype

-- Track each globin's base max HP to prevent infinite scaling
local originalMaxHp = {}

local function onNPCDeath(_, npc)
    -- Check if this is a Cursed Globin
    if npc.Type ~= CURSED_GLOBIN_TYPE then return end
    if npc.SubType ~= CURSED_SUBTYPE then return end

    local ptr = GetPtrHash(npc)
    if not originalMaxHp[ptr] then
        originalMaxHp[ptr] = npc.MaxHitPoints
    end
end

local function onNPCUpdate(_, npc)
    -- Check for revived Cursed Globins and buff them
    if npc.Type ~= CURSED_GLOBIN_TYPE then return end
    if npc.SubType ~= CURSED_SUBTYPE then return end
    if npc:IsDead() then return end

    local ptr = GetPtrHash(npc)
    
    -- Detect if this Globin has revived (its HP would be full but it has history of dying)
    if originalMaxHp[ptr] and npc.HitPoints >= npc.MaxHitPoints * 0.95 then
        -- It revived: boost its HP by 50%
        if npc.MaxHitPoints < originalMaxHp[ptr] * 1.5 then
            npc.MaxHitPoints = math.floor(originalMaxHp[ptr] * 1.5)
            npc.HitPoints = npc.MaxHitPoints
            npc.Scale = npc.Scale * 1.1
            -- Darker tint to indicate empowered state
            npc.Color = Color(0.6, 0.2, 0.6, 1.0, 0, 0, 0)
            originalMaxHp[ptr] = nil  -- Prevent further scaling
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, onNPCDeath)
mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("CursedGlobinRevive loaded!")
