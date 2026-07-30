local mod = RegisterMod("GameDevilAngelChance", 1)
local game = Game()

function mod:onRender()
    local devil = game:GetDevilRoomChance()
    local angel = game:GetAngelRoomChance()
    Isaac.RenderText("Devil: " .. tostring(devil) .. "%", 50, 50, 1, 0, 0, 255)
    Isaac.RenderText("Angel: " .. tostring(angel) .. "%", 50, 65, 0.5, 1, 1, 255)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
