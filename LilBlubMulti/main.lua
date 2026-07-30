-- ==========================================================================
--  Lil Blub Multi - The Binding of Isaac: Repentance
--  Lil Blub splits into 3 smaller blubs at death, bouncing independently.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("LilBlubMulti", 1)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if npc.Type == EntityType.ENTITY_LIL_BLUB then
        local room = Game():GetRoom()
        if not room then return end

        for i = 1, 3 do
            local angle = (i / 3) * math.pi * 2
            local spawnPos = npc.Position + Vector.FromAngle(angle) * 30
            local miniBlub = Isaac.Spawn(EntityType.ENTITY_LIL_BLUB, 0, 0, spawnPos,
                Vector.FromAngle(angle) * 4, npc)
            if miniBlub then
                miniBlub.SpriteScale = Vector(0.5, 0.5)
                miniBlub:ToNPC().HitPoints = math.floor(npc.MaxHitPoints * 0.3)
                miniBlub:AddEntityFlags(EntityFlag.FLAG_BOUNCE)
            end
        end
    end
end)

Isaac.DebugString("LilBlubMulti loaded!")
