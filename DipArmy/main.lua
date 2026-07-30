-- =============================================================================
--  DipArmy -- The Binding of Isaac: Repentance
--  Dips (Type=51) multiply into 3 more Dips after 10 seconds alive.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DipArmy", 1)
local SPAWN_DELAY = 300 -- 10 seconds at 30fps

function mod:onNpcUpdate(npc)
    if npc.Type ~= 51 then return end
    local data = npc:GetData()
    data.spawnTimer = (data.spawnTimer or 0) + 1
    if data.spawnTimer < SPAWN_DELAY then return end
    data.spawnTimer = -999999 -- prevent re-trigger
    for i = 1, 3 do
        local offset = Vector(math.random(-20, 20), math.random(-20, 20))
        Isaac.Spawn(EntityType.ENTITY_DIP, 0, 0, npc.Position + offset, Vector.Zero, nil)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("DipArmy loaded!")
