-- =============================================================================
--  PreGameExitSave - The Binding of Isaac: Repentance
--  Auto-saves room and floor info before exiting a run.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PreGameExitSave", 1)

function mod:onPreGameExit(shouldSave)
    if not shouldSave then return end
    local game = Game()
    local level = game:GetLevel()
    local room = game:GetRoom()

    -- Save floor and room to persistent data slots
    mod:SetSaveData(1, level:GetStage())
    mod:SetSaveData(2, level:GetStageType())
    mod:SetSaveData(3, room:GetType())

    Isaac.DebugString("Game exiting — progress saved to slot.")
end

mod:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, mod.onPreGameExit)
Isaac.DebugString("PreGameExitSave loaded!")
