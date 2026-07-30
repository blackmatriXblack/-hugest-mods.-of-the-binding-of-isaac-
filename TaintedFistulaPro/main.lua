-- ==========================================================================
--  Tainted Fistula Pro - The Binding of Isaac: Repentance
--  Tainted Fistula — each segment champion-randomizes.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TaintedFistulaPro", 1)
local champion_types = {0, 1, 2, 3, 4, 5}

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == EntityType.ENTITY_FISTULA_BIG or
       npc.Type == EntityType.ENTITY_FISTULA_MEDIUM or
       npc.Type == EntityType.ENTITY_FISTULA_SMALL then
        if npc.FrameCount <= 2 then
            local champ_type = champion_types[math.random(#champion_types)]
            npc:ToNPC():SetChampion(champ_type, true)
        end
    end
end)

Isaac.DebugString("TaintedFistulaPro loaded!")
