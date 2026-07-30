-- ==========================================================================
--  Tainted Duke of Flies Hive - The Binding of Isaac: Repentance
--  Tainted Duke of Flies — summons level 2 flies instead of regular.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TaintedDukeOfFliesHive", 1)
local DUKE_ID = EntityType.ENTITY_DUKE_OF_FLIES

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == DUKE_ID then
        local room = Game():GetRoom()
        if not room then return end

        if npc.FrameCount % 60 == 0 then
            for i = 1, 3 do
                local angle = i * 2.09 + math.random() * 0.5
                local flyPos = npc.Position + Vector.FromAngle(angle) * 40
                local fly = Isaac.Spawn(EntityType.ENTITY_FLY, 1, 0,
                    flyPos, Vector.FromAngle(math.random() * math.pi * 2) * 3, npc)
                if fly then
                    fly:AddEntityFlags(EntityFlag.FLAG_CHAMPION)
                end
            end
        end
    end
end)

Isaac.DebugString("TaintedDukeOfFliesHive loaded!")
