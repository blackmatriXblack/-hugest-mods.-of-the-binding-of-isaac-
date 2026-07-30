-- ==========================================================================
--  Tainted Larry Jr Morph - The Binding of Isaac: Repentance
--  Tainted Larry Jr. — morphs body segments into different enemy types.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TaintedLarryJrMorph", 1)
local LARRY_JR_ID = EntityType.ENTITY_LARRY_JR
local enemy_types = {EntityType.ENTITY_GAPER, EntityType.ENTITY_HORF, EntityType.ENTITY_FLY, EntityType.ENTITY_SPIDER, EntityType.ENTITY_DIP}
local morph_timers = {}

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == LARRY_JR_ID then
        if not morph_timers[npc.InitSeed] then
            morph_timers[npc.InitSeed] = 0
        end
        morph_timers[npc.InitSeed] = morph_timers[npc.InitSeed] + 1

        if morph_timers[npc.InitSeed] % 120 == 0 and morph_timers[npc.InitSeed] > 0 then
            local entities = Isaac.GetRoomEntities()
            local segmentCount = 0
            for _, ent in ipairs(entities) do
                if ent.Type == LARRY_JR_ID and ent.Index ~= npc.Index and segmentCount < 3 then
                    local newType = enemy_types[math.random(#enemy_types)]
                    ent:ToNPC():MorphToType(newType, 0, 0, 0)
                    segmentCount = segmentCount + 1
                end
            end
        end
    end
end)

Isaac.DebugString("TaintedLarryJrMorph loaded!")
