-- =============================================================================
--  RNGSeedDisplay — The Binding of Isaac: Repentance
--  Display current run seed and seed-derived luck modifier on HUD.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RNGSeedDisplay", 1)
local game = Game()

function mod:onPostRender()
    local seeds = game:GetSeeds()
    local startSeed = seeds:GetStartSeedString()
    local rng = RNG()
    rng:SetSeed(game:GetSeeds():GetStartSeed(), 0)
    local luckModifier = rng:RandomFloat() * 2 - 1 -- seed-derived luck in range [-1, 1]
    local text = "Seed: " .. startSeed .. " | Luck Mod: " .. string.format("%.3f", luckModifier)
    Isaac.RenderText(text, 10, 10, 1, 1, 1, 1)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("RNGSeedDisplay loaded!")
