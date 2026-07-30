local mod = RegisterMod("VectorMathDemo", 1)

function mod:onRender()
    local player = Isaac.GetPlayer(0)
    local v1 = Vector(3, 4)
    local len = v1:Length()
    local v2 = v1:Rotated(90)
    local dot = v1:Dot(v2)
    local lerp = v1:Lerp(v2, 0.5)
    Isaac.RenderText("Len:" .. string.format("%.1f", len), 50, 50, 1, 1, 1, 255)
    Isaac.RenderText("Dot:" .. string.format("%.1f", dot), 50, 65, 1, 1, 1, 255)
    Isaac.RenderText("Lerp:" .. string.format("%.1f,%.1f", lerp.X, lerp.Y), 50, 80, 1, 1, 1, 255)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
