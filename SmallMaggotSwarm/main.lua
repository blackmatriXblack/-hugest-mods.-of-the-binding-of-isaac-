-- =============================================================================
--  SmallMaggotSwarm - The Binding of Isaac: Repentance
--  Small Maggots burst into a swarm of 3 even tinier maggots upon death
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SmallMaggotSwarm", 1)
local SMALL_MAGGOT_TYPE = 21  -- EntityType.ENTITY_MAGGOT

function mod:onNpcDeath(_, npc)
    if npc.Type == SMALL_MAGGOT_TYPE then
        local pos = npc.Position
        local room = Game():GetRoom()
        for i = 1, 3 do
            local offset = Vector(math.random(-30, 30), math.random(-30, 30))
            local spawnPos = pos + offset
            -- Clamp within room bounds to avoid spawning in walls
            spawnPos = room:GetClampedPosition(spawnPos, 20)
            local baby = Isaac.Spawn(SMALL_MAGGOT_TYPE, 0, 0, spawnPos, RandomVector():Resized(2 + math.random() * 2), npc)
            if baby then
                baby:AddEntityFlags(EntityFlag.FLAG_APPEAR)
                baby.Scale = 0.6  -- Even smaller!
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.onNpcDeath)
Isaac.DebugString("SmallMaggotSwarm loaded!")
