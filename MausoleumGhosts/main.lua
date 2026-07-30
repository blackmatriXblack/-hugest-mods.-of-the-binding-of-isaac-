-- =============================================================================
--  MausoleumGhosts - The Binding of Isaac: Repentance
--  Mausoleum floors have 20% chance to convert enemies into spectral ghost variants
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MausoleumGhosts", 1)

local function IsMausoleum()
    local level = Game():GetLevel()
    local stage = level:GetStage()
    -- Mausoleum = stage 4 (Womb) with REPENTANCE_B type (alt path post-Mines)
    return (stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2)
       and (level:GetStageType() == StageType.STAGETYPE_REPENTANCE_B
        or level:GetStageType() == StageType.STAGETYPE_REPENTANCE)
end

local function OnEntitySpawn(entity)
    if not IsMausoleum() then return end

    -- Only affect regular enemies, not bosses or special entities
    if not entity:IsVulnerableEnemy() then return end
    if entity:IsBoss() then return end

    -- 20% chance to convert to ghost variant
    if math.random(1, 100) > 20 then return end

    local ghost = Isaac.Spawn(
        entity.Type,
        entity.Variant,
        entity.SubType,
        entity.Position,
        entity.Velocity,
        entity:SpawnerEntity()
    )

    if ghost then
        -- Make the ghost spectral (passes through obstacles)
        ghost:AddEntityFlags(EntityFlag.FLAG_GHOST)
        -- Copy HP from original monster
        ghost:SetMaxHitPoints(entity.MaxHitPoints)
        ghost.HitPoints = entity.HitPoints
        -- Remove the original non-ghost enemy
        entity:Remove()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, OnEntitySpawn)
Isaac.DebugString("MausoleumGhosts loaded!")
