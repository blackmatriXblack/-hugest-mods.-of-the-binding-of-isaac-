local mod = RegisterMod("GameRoomCount", 1)
local game = Game()

function mod:onRender()
    local count = game:GetRoomCount()
    Isaac.RenderText("Rooms visited: " .. tostring(count), 50, 50, 1, 1, 1, 255)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
