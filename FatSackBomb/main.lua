-- =============================================================================
--  FatSackBomb - The Binding of Isaac: Repentance
--  Fat Sacks drop 2 live bombs upon death, turning their corpse into a trap
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FatSackBomb", 1)
local FAT_SACK_TYPE = 249

function mod:onNpcDeath(_, npc)
    if npc.Type ~= FAT_SACK_TYPE then return end
    local pos = npc.Position

    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF, 0, pos, Vector.Zero, npc)

    for i = 1, 2 do
        local offsetX = (i == 1 and -20 or 20)
        local bombPos = pos + Vector(offsetX + math.random(-5, 5), math.random(-5, 5))
        local bomb = Isaac.Spawn(EntityType.ENTITY_BOMBDROP, 0, 0, bombPos, Vector.Zero, npc)
        if bomb then
            local bombEnt = bomb:ToBomb()
            if bombEnt then
                bombEnt.ExplosionDamage = 50
                bombEnt.RadiusMultiplier = 1.2
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.onNpcDeath)
Isaac.DebugString("FatSackBomb loaded!")
