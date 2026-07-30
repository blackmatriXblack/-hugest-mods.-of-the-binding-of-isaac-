-- ==========================================================================
--  BlisterBurst - The Binding of Isaac: Repentance
--  Blister bursts into 3 smaller blisters on death dealing contact damage
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("BlisterBurst", 1)
local game = Game()
local BLISTER_TYPE = EntityType.ENTITY_BLISTER

function mod:burstDeath(_, npc)
    if npc.Type ~= BLISTER_TYPE then return end
    for i = 0, 2 do
        local angle = i * 2.09
        local spawnPos = npc.Position + Vector(math.cos(angle) * 20, math.sin(angle) * 20)
        local mini = Isaac.Spawn(BLISTER_TYPE, 0, 0, spawnPos, Vector(math.cos(angle), math.sin(angle)):Resized(4), npc)
        if mini then
            mini.SpriteScale = Vector(0.5, 0.5)
            mini:AddEntityFlags(EntityFlag.FLAG_CHASE)
        end
    end
    Isaac.Explode(npc.Position, npc, 0)
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.burstDeath, BLISTER_TYPE)
Isaac.DebugString("BlisterBurst loaded!")
