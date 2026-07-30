local mod = RegisterMod("SeedDisplay", 1)
local game = Game()

function mod:onRender()
    local seed = game:GetSeeds():GetStartSeed()
    local hex = string.format("%08X", seed)
    Isaac.RenderText("Seed: " .. hex, 10, 20, 1, 1, 1, 0, 1)
end

mod:AddCallback(4, mod.onRender) -- MC_POST_RENDER
Isaac.DebugString("SeedDisplay: Current run seed displayed on HUD!")
