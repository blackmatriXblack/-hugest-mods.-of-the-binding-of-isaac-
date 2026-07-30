local mod = RegisterMod("LevelStageOverride", 1)
local game = Game()

function mod:onNewLevel()
    local level = game:GetLevel()
    local stageType = level:GetStageType()
    local absStage = level:GetAbsoluteStage()
    Isaac.DebugString("StageType: " .. tostring(stageType) .. " AbsStage: " .. tostring(absStage))
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
