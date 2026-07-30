-- =============================================================================
--  DankDepthsMold - The Binding of Isaac: Repentance
--  Dank Depths floors spawn random mold patches that slow and poison the player
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DankDepthsMold", 1)

local function IsDankDepths()
    local level = Game():GetLevel()
    local stage = level:GetStage()
    return (stage == LevelStage.STAGE3_1 or stage == LevelStage.STAGE3_2)
       and level:GetStageType() == StageType.STAGETYPE_REPENTANCE
end

local function SpawnMoldPatches()
    if not IsDankDepths() then return end

    -- 60% chance per room to spawn mold patches
    if math.random(1, 100) > 60 then return end

    local room = Game():GetRoom()
    local center = room:GetCenterPos()

    -- Spawn 3-6 creeping mold spots that slow the player
    local moldCount = math.random(3, 6)
    for i = 1, moldCount do
        local offsetX = math.random(-100, 100)
        local offsetY = math.random(-100, 100)
        local pos = Vector(center.X + offsetX, center.Y + offsetY)

        -- Creep with green trail (mold/pesticide), damage = 1, slow effect
        local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_GREEN, 0, pos, Vector.Zero, nil)
        if creep then
            creep:SetTimeout(300 + math.random(0, 200)) -- 10-16 seconds
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SpawnMoldPatches)
Isaac.DebugString("DankDepthsMold loaded!")
