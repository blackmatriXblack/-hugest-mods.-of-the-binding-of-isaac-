-- Draw "You are here!" text near the player using world-to-screen coordinates
local mod = RegisterMod("WorldToScreenHUD", 1)
local game = Game()

function mod:onPostRender()
    local player = Isaac.GetPlayer(0)
    if player then
        local screenPos = Isaac.WorldToScreen(player.Position)
        Isaac.RenderText("You are here!", screenPos.X - 50, screenPos.Y - 20, 1, 1, 0, 1)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("WorldToScreenHUD loaded! Draws 'You are here!' near the player.")
