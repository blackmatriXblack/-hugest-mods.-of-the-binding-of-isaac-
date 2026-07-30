-- =============================================================================
--  ScarredWombBleed - The Binding of Isaac: Repentance
--  Scarred Womb rooms occasionally spawn creeping blood patches on the floor
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ScarredWombBleed", 1)

local function IsScarredWomb()
    local level = Game():GetLevel()
    local stage = level:GetStage()
    return (stage == LevelStage.STAGE4_1 or stage == LevelStage.STAGE4_2)
       and level:GetStageType() == StageType.STAGETYPE_REPENTANCE
end

local function SpawnBleedPatches()
    if not IsScarredWomb() then return end

    -- 45% chance per room
    if math.random(1, 100) > 45 then return end

    local room = Game():GetRoom()
    local center = room:GetCenterPos()

    -- Spawn 2-5 blood creep patches
    local count = math.random(2, 5)
    for i = 1, count do
        local pos = Vector(
            center.X + math.random(-120, 120),
            center.Y + math.random(-120, 120)
        )

        -- Red creep (blood) that damages on contact, timeout 8-14 seconds
        local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, pos, Vector.Zero, nil)
        if creep then
            creep:SetTimeout(240 + math.random(0, 180))
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SpawnBleedPatches)
Isaac.DebugString("ScarredWombBleed loaded!")
