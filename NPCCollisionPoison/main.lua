-- =============================================================================
--  NPCCollisionPoison — The Binding of Isaac: Repentance
--  When enemies bump into each other, both get poisoned.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("NPCCollisionPoison", 1)

function mod:onNPCCollision(npc1, npc2, low)
    if npc1 and npc2 then
        if npc1:IsVulnerableEnemy() and npc2:IsVulnerableEnemy() then
            -- Poison both enemies for 3 seconds, dealing 4 damage per tick
            npc1:AddPoison(EntityRef(npc1), 120, 3)
            npc2:AddPoison(EntityRef(npc2), 120, 3)
            -- Visual feedback: green puff effects
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, npc1.Position, Vector.Zero, nil)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, npc2.Position, Vector.Zero, nil)
            Isaac.DebugString("NPCCollisionPoison: Enemies poisoned each other!")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_COLLISION, mod.onNPCCollision)
Isaac.DebugString("NPCCollisionPoison loaded!")
