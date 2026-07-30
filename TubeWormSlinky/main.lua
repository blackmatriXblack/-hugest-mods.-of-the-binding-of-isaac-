-- =============================================================================
--  TubeWormSlinky — The Binding of Isaac: Repentance
--  Tube Worms (Type=244) leave a slowing creep trail.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TubeWormSlinky", 1)

function mod:onNpcUpdate(npc)
    if npc.Type ~= 244 then return end
    -- spawn slowing creep effect at NPC position every few frames
    if math.random(1, 5) ~= 1 then return end
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_SLOW, 0,
        npc.Position, Vector.Zero, npc)
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("TubeWormSlinky loaded!")
