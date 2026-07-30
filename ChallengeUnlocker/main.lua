-- =============================================================================
--  ChallengeUnlocker — The Binding of Isaac: Repentance
--  List all challenges on screen with completion status.
--  Version: 1.0   | Official API only
-- =============================================================================

local mod = RegisterMod("ChallengeUnlocker", 1)
local game = Game()

function mod:onPostRender()
    -- Press key to toggle challenge list display
    if Input.IsButtonTriggered(Keyboard.KEY_C, 0) then
        mod.showList = not mod.showList
    end
    if not mod.showList then return end

    local challenges = game:GetChallenges()
    local count = challenges:Size()
    local yOffset = 10
    Isaac.RenderText("Challenges (" .. tostring(count) .. "):", 10, yOffset, 1, 1, 1, 1)
    yOffset = yOffset + 14

    for i = 0, math.min(count - 1, 30) do
        local challenge = challenges:Get(i)
        if challenge then
            local completed = challenge:IsCompleted()
            local prefix = completed and "[X]" or "[ ]"
            local line = prefix .. " " .. challenge:GetName()
            Isaac.RenderText(line, 10, yOffset, 0.7, 0.7, completed and 0 or 1, 1, completed and 0 or 1)
            yOffset = yOffset + 10
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("ChallengeUnlocker loaded!")
