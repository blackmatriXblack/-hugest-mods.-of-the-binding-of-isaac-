-- Draw text around the player during player render
local mod = RegisterMod("PlayerRenderMod", 1)
local game = Game()

function mod:onPlayerRender(player, renderOffset)
    if player then
        local screenPos = Isaac.WorldToScreen(player.Position)
        Isaac.RenderText("P", screenPos.X - 4, screenPos.Y - 30, 0, 1, 1, 2)
        Isaac.RenderText("=", screenPos.X - 4, screenPos.Y + 20, 0, 1, 1, 2)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, mod.onPlayerRender)
Isaac.DebugString("PlayerRenderMod loaded! Draws text around the player.")
