-- ==========================================================================
--  Tainted Mega Satan Skull - The Binding of Isaac: Repentance
--  Tainted Mega Satan — summons champion sins instead of regular sins.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TaintedMegaSatanSkull", 1)
local sin_types = {EntityType.ENTITY_SLOTH, EntityType.ENTITY_LUST, EntityType.ENTITY_WRATH, EntityType.ENTITY_GLUTTONY, EntityType.ENTITY_GREED, EntityType.ENTITY_ENVY, EntityType.ENTITY_PRIDE}

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == EntityType.ENTITY_MEGA_SATAN then
        local room = Game():GetRoom()
        if not room then return end

        if npc.FrameCount % 100 == 0 then
            local sinType = sin_types[math.random(#sin_types)]
            local spawnPos = room:FindFreePickupSpawnPosition(npc.Position, 50, true)
            local sin = Isaac.Spawn(sinType, 0, 0, spawnPos, Vector.Zero, npc)
            if sin then
                sin:ToNPC():MakeChampion(0, math.random(1, 5), true)
                sin:AddEntityFlags(EntityFlag.FLAG_CHAMPION)
            end
        end
    end
end)

Isaac.DebugString("TaintedMegaSatanSkull loaded!")
