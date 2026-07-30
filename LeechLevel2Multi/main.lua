-- ==========================================================================
--  LeechLevel2Multi - The Binding of Isaac: Repentance
--  Level 2 Leech spawns 2 regular leeches on death.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("LeechLevel2Multi", 1)
local ENEMY_LEECH = 48

local function onNPCDeath(_, npc)
    if npc.Type ~= ENEMY_LEECH or npc.Variant ~= 1 then return end
    local pos = npc.Position
    for i = 1, 2 do
        local offset = Vector(math.random(-30, 30), math.random(-30, 30))
        Isaac.Spawn(EntityType.ENTITY_LEECH, 0, 0, pos + offset, Vector(math.random(-2, 2), math.random(-2, 2)), npc)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, onNPCDeath)
Isaac.DebugString("LeechLevel2Multi loaded!")