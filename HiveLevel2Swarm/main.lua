-- ==========================================================================
--  HiveLevel2Swarm - The Binding of Isaac: Repentance
--  Level 2 Hive spawns 3 dips per cycle instead of 1.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("HiveLevel2Swarm", 1)
local ENEMY_HIVE = 22
local SPAWN_COOLDOWN = 60

local function onNPCUpdate(_, npc)
    if npc.Type == ENEMY_HIVE and npc.Variant == 1 then
        local data = npc:GetData()
        if not data.swarmTimer then
            data.swarmTimer = 0
        end
        data.swarmTimer = data.swarmTimer + 1
        if data.swarmTimer >= SPAWN_COOLDOWN then
            data.swarmTimer = 0
            local room = Game():GetRoom()
            for i = 1, 3 do
                local pos = npc.Position + Vector(math.random(-40, 40), math.random(-40, 40))
                Isaac.Spawn(EntityType.ENTITY_DIP, 0, 0, pos, Vector.Zero, npc)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("HiveLevel2Swarm loaded!")
