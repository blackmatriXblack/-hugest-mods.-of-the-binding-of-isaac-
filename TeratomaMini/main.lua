-- =============================================================================
--  Teratoma Champion Spawns - The Binding of Isaac: Repentance
--  All spiders spawned by Teratoma are random champion variants.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TeratomaMini", 1)

local TERATOMA_TYPE = 71    -- EntityType.ENTITY_TERATOMA
local SPIDER_TYPE = 25      -- EntityType.ENTITY_SPIDER

local championColors = {
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
}

local function onNPCUpdate(_, npc)
    if npc.Type ~= TERATOMA_TYPE then return end
    if npc:IsDead() then return end

    -- When Teratoma is attacking/spawning, make nearby spiders champions
    if npc.State == NpcState.STATE_ATTACK2 or npc.State == NpcState.STATE_SPECIAL then
        local entities = Isaac.GetRoomEntities()
        for _, ent in ipairs(entities) do
            if ent.Type == SPIDER_TYPE and not ent:IsDead() then
                -- Only upgrade normal (non-champion) spiders
                if ent:GetChampionColorIdx() == 0 then
                    local champColor = championColors[math.random(1, #championColors)]
                    ent:SetChampionColor(champColor, true)
                end
            end
        end
    end

    -- Also handle newly spawned spiders by Teratoma
    local entities = Isaac.GetRoomEntities()
    for _, ent in ipairs(entities) do
        if ent.Type == SPIDER_TYPE and not ent:IsDead() then
            if ent.FrameCount <= 2 and ent.SpawnerType == TERATOMA_TYPE then
                if ent:GetChampionColorIdx() == 0 then
                    local champColor = championColors[math.random(1, #championColors)]
                    ent:SetChampionColor(champColor, true)
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("TeratomaMini loaded!")
