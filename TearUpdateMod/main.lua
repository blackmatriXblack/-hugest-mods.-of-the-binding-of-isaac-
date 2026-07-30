-- Adjust tear velocity slightly for a speed boost
local mod = RegisterMod("TearUpdateMod", 1)
local game = Game()

function mod:onTearUpdate(tear)
    if tear and tear.Velocity then
        tear.Velocity = tear.Velocity * 1.02
    end
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.onTearUpdate)
Isaac.DebugString("TearUpdateMod loaded! Boosts tear velocity by 2% per frame.")
