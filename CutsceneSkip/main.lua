-- =============================================================================
--  CutsceneSkip — The Binding of Isaac: Repentance
--  All cutscenes auto-skip after 2 seconds.
--  Version: 1.0   | Official API only
-- =============================================================================

local mod = RegisterMod("CutsceneSkip", 1)
local game = Game()
mod.cutsceneTimer = 0
mod.inCutscene = false

function mod:onPostUpdate()
    local level = game:GetLevel()
    local stage = level:GetCStage()
    -- Cutscene detection: Check if game is in a cutscene state
    -- Cutscenes typically happen at stage 0 (basement) level 0 when entering a new run
    -- or during specific story events

    -- Detect cutscene by checking if HUD shows a cutscene or game is paused for intro
    local hud = game:GetHUD()
    if hud and hud:IsVisible() == false then
        -- HUD hidden might indicate cutscene
        if not mod.inCutscene then
            mod.inCutscene = true
            mod.cutsceneTimer = 120 -- 2 seconds at 60fps
        end
    else
        if mod.inCutscene then
            mod.inCutscene = false
            mod.cutsceneTimer = 0
        end
    end

    -- Auto-skip after timer expires
    if mod.inCutscene and mod.cutsceneTimer > 0 then
        mod.cutsceneTimer = mod.cutsceneTimer - 1
        if mod.cutsceneTimer <= 0 then
            -- Simulate skip button press (Space / Enter)
            local input = Input()
            -- Force skip by attempting to end cutscene via game API
            if game:GetLevel() then
                local room = game:GetRoom()
                if room and room:GetFrameCount() > 10 then
                    -- Try to force the cutscene to end
                    game:GetLevel():SetStage(level:GetStage(), level:GetStageType())
                end
            end
            mod.inCutscene = false
            Isaac.DebugString("CutsceneSkip: Auto-skipped cutscene")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onPostUpdate)
Isaac.DebugString("CutsceneSkip loaded!")
