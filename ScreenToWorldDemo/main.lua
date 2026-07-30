local mod = RegisterMod("ScreenToWorldDemo", 1)
local input = Input()

function mod:onRender()
    local mousePos = input:GetMousePosition(true)
    local worldPos = Isaac.ScreenToWorld(mousePos)
    Isaac.RenderText("Mouse Screen: " .. string.format("%.0f,%.0f", mousePos.X, mousePos.Y), 50, 50, 1, 1, 1, 255)
    Isaac.RenderText("World: " .. string.format("%.0f,%.0f", worldPos.X, worldPos.Y), 50, 65, 1, 1, 1, 255)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
