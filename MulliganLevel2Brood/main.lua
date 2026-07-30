-- ==========================================================================
--  MulliganLevel2Brood - The Binding of Isaac: Repentance
--  Level 2 Mulligan spawns 4 attack flies on death.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("MulliganLevel2Brood", 1)
local ENEMY_MULLIGAN = 24

local function onNPCDeath(_, npc)
    if npc.Type ~= ENEMY_MULLIGAN or npc.Variant ~= 1 then return end
    local pos = npc.Position
    for i = 1, 4 do
        local offset = Vector(math.random(-40, 40), math.random(-40, 40))
        local vel = Vector(math.random(-3, 3), math.random(-3, 3))
        Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0, 0, pos + offset, vel, npc)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, onNPCDeath)
Isaac.DebugString("MulliganLevel2Brood loaded!")