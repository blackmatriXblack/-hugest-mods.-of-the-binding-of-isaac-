local mod = RegisterMod("PlayerMovementDirection", 1)
local game = Game()
local ArrowIcons = {[0]="O", [1]="^", [2]="v", [3]="<", [4]=">"}

function mod:onRender()
    local player = Isaac.GetPlayer(0)
    local dir = player:GetMovementDirection()
    local arrow = ArrowIcons[dir] or "?"
    Isaac.RenderText("Direction: " .. arrow .. " [" .. tostring(dir) .. "]", 50, 50, 1, 1, 1, 255)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
