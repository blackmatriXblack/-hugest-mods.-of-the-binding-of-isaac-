-- =============================================================================
--  PsychicMawTelekinesis — The Binding of Isaac: Repentance
--  Psychic Maws (Type=14, Variant=2) reflect tears back at the player.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PsychicMawTelekinesis", 1)

function mod:onPreNpcCollision(npc, collider, low)
    if npc.Type ~= 14 or npc.Variant ~= 2 then return end

    -- Check if the collider is a player tear
    if collider.Type == EntityType.ENTITY_TEAR then
        local player = Isaac.GetPlayer(0)
        if not player then return end

        local reflectDir = (player.Position - npc.Position):Normalized()
        collider.Velocity = reflectDir * collider.Velocity:Length()
        -- Change tear ownership so it can damage the player
        if collider.TearFlags then
            collider:AddTearFlags(TearFlags.TEAR_HOMING)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.onPreNpcCollision)
Isaac.DebugString("PsychicMawTelekinesis loaded!")
