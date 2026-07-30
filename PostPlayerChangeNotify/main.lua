-- =============================================================================
--  PostPlayerChangeNotify - The Binding of Isaac: Repentance
--  Displays on-screen notification when character form changes.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PostPlayerChangeNotify", 1)
local notifyText = ""
local notifyTimer = 0

function mod:onPostPlayerChange(player)
    notifyTimer = 120 -- 4 seconds at 30fps
    if player:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
        notifyText = "Form: The Forgotten (Body)"
    elseif player:GetPlayerType() == PlayerType.PLAYER_THESOUL then
        notifyText = "Form: The Soul"
    elseif player:GetPlayerType() == PlayerType.PLAYER_LAZARUS then
        notifyText = "Form: Lazarus"
    elseif player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2 then
        notifyText = "Form: Lazarus Risen"
    else
        notifyText = "Form: " .. player:GetName()
    end
end

function mod:onPostRender()
    if notifyTimer <= 0 then return end
    notifyTimer = notifyTimer - 1
    Isaac.RenderText(notifyText, 60, 60, 1, 1, 1, 1)
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_CHANGE, mod.onPostPlayerChange)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("PostPlayerChangeNotify loaded!")
