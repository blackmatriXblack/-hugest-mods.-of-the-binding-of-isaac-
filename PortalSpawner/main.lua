-- =============================================================================
--  PortalSpawner -- The Binding of Isaac: Repentance
--  Portals (Type=74) spawn enemies from deeper floors (Womb enemies in Basement).
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PortalSpawner", 1)
local DEEP_ENEMIES = {88, 89, 90, 91, 215, 216, 217, 227, 228, 229}

function mod:onNpcUpdate(npc)
    if npc.Type ~= 74 then return end
    if npc.FrameCount % 180 ~= 0 then return end
    local enemyType = DEEP_ENEMIES[math.random(1, #DEEP_ENEMIES)]
    local offset = Vector(math.random(-40, 40), math.random(-40, 40))
    Isaac.Spawn(enemyType, 0, 0, npc.Position + offset, Vector.Zero, nil)
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("PortalSpawner loaded!")
