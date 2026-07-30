-- =============================================================================
--  CorpseFloorChampion — The Binding of Isaac: Repentance
--  All enemies on Corpse floors are automatically champions.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CorpseFloorChampion", 1)

local CORPSE_STAGE = LevelStage.STAGE_CORPSE
local CORPSE_STAGE2 = LevelStage.STAGE_CORPSE_2

local GRIEF_STAGE = LevelStage.STAGE_REPENTANCE
local GRIEF_STAGE2 = LevelStage.STAGE_REPENTANCE_B

function mod:OnEntitySpawn(entity)
    if not entity:IsEnemy() then return end
    if entity:IsBoss() then return end

    local level = Game():GetLevel()
    local stage = level:GetStage()

    if stage == CORPSE_STAGE or stage == CORPSE_STAGE2 or
       stage == GRIEF_STAGE or stage == GRIEF_STAGE2 then
        -- Corpse floor — make champion
        if not entity:IsChampion() then
            entity:MakeChampion()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.OnEntitySpawn)
Isaac.DebugString("CorpseFloorChampion loaded!")
