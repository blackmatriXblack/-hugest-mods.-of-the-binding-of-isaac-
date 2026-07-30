-- =============================================================================
--  AllChampionMode - The Binding of Isaac: Repentance
--  Every enemy is a random champion variant
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("AllChampionMode", 1)
local game = Game()
local championedEntities = {}

function mod:onPostEntitySpawn(entity)
    if not entity:IsActiveEnemy() then return end
    if entity:IsBoss() then return end -- Boss champions would be insane

    -- Skip if already championed
    local uid = entity.Index
    if championedEntities[uid] then return end

    -- Check if already a champion
    if entity:IsChampion() then
        championedEntities[uid] = true
        return
    end

    -- Make the entity a random champion
    -- Champion types range from 0-12 depending on enemy type
    local championType = entity:GetChampionColorIdx()

    local attempts = 0
    while (championType == 0 or championType == entity:GetChampionColorIdx()) and attempts < 10 do
        championType = math.random(1, 12)
        attempts = attempts + 1
    end

    if championType > 0 then
        entity:MakeChampion(championType, RNG():RandomInt(9999999), true)
        championedEntities[uid] = true
    end

    -- Cleanup periodically
    if game:GetFrameCount() % 600 == 0 then
        championedEntities = {}
    end
end

function mod:onPostRender()
    Isaac.RenderText(
        "[ALL CHAMPION MODE]",
        220, 4,
        1.0, 0.8, 0.0, 0.8
    )
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onPostEntitySpawn)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)

Isaac.DebugString("AllChampionMode loaded! Every enemy is a champion.")
