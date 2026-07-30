-- ==========================================================================
--  Tainted Isaac Boss Angel - The Binding of Isaac: Repentance
--  Tainted Isaac (boss) — summons angel babies that heal him.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TaintedIsaacBossAngel", 1)

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == EntityType.ENTITY_ISAAC_BOSS then
        local player = Isaac.GetPlayer(0)
        if not player then return end

        if npc.FrameCount % 120 == 0 then
            local angel = Isaac.Spawn(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ANGEL, 0,
                npc.Position + Vector(0, -40), Vector.Zero, npc)
            if angel then
                npc:AddHealth(math.min(20, npc.MaxHitPoints - npc.HitPoints))
            end
        end
    end
end)

Isaac.DebugString("TaintedIsaacBossAngel loaded!")
