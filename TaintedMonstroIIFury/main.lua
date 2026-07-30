-- ==========================================================================
--  Tainted Monstro II Fury - The Binding of Isaac: Repentance
--  Tainted Monstro II — splits into 4 mini-monstros instead of 2.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TaintedMonstroIIFury", 1)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if npc.Type == EntityType.ENTITY_MONSTRO_II then
        local room = Game():GetRoom()
        if not room then return end

        for i = 1, 4 do
            local angle = (i / 4) * math.pi * 2
            local spawnPos = npc.Position + Vector.FromAngle(angle) * 60
            local mini = Isaac.Spawn(EntityType.ENTITY_MONSTRO, 0, 0,
                spawnPos, Vector.FromAngle(angle) * 2, npc)
            if mini then
                mini:AddEntityFlags(EntityFlag.FLAG_CHAMPION)
                mini.SpriteScale = Vector(0.6, 0.6)
            end
        end
    end
end)

Isaac.DebugString("TaintedMonstroIIFury loaded!")
