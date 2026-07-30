-- ==========================================================================
--  Tainted Blue Baby Boss - The Binding of Isaac: Repentance
--  Tainted ??? boss — every fly spawned is a boom fly.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TaintedBlueBabyBoss", 1)

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == EntityType.ENTITY_BLUEBABY then
        local player = Isaac.GetPlayer(0)
        if not player then return end

        if npc.FrameCount % 50 == 0 then
            for i = 1, 3 do
                local boomFly = Isaac.Spawn(EntityType.ENTITY_BOOMFLY, 0, 0,
                    npc.Position + Vector.FromAngle(i * 2.09) * 50,
                    Vector.FromAngle(math.random() * math.pi * 2) * 3, npc)
                if boomFly then
                    boomFly:AddEntityFlags(EntityFlag.FLAG_CHAMPION)
                end
            end
        end
    end
end)

Isaac.DebugString("TaintedBlueBabyBoss loaded!")
