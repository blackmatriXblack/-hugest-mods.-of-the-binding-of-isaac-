-- =============================================================================
--  CathedralBlessing - The Binding of Isaac: Repentance
--  Entering the Cathedral grants the player +1 Eternal Heart as a blessing
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CathedralBlessing", 1)

local function IsCathedral()
    local level = Game():GetLevel()
    return level:GetStage() == LevelStage.STAGE6
       and level:GetStageType() == StageType.STAGETYPE_ORIGINAL
end

local function GrantBlessing()
    if not IsCathedral() then return end

    local player = Isaac.GetPlayer(0)
    if not player then return end

    -- Grant +1 Eternal Heart
    player:AddEternalHearts(1)

    -- Spawn a small heavenly effect for feedback
    local effect = Isaac.Spawn(
        EntityType.ENTITY_EFFECT,
        EffectVariant.HALO,
        0,
        player.Position,
        Vector.Zero,
        player
    )
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, GrantBlessing)
Isaac.DebugString("CathedralBlessing loaded!")
