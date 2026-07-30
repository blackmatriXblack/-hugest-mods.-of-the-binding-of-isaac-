-- RNGControl: Re-seeds RNG to fixed value on each floor for predictable randomness
local mod = RegisterMod("RNGControl", 1)

function mod:onNewLevel()
    local rng = RNG()
    rng:SetSeed(12345, 0)
    Isaac.DebugString("RNGControl: RNG re-seeded to 12345 for this floor!")
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
Isaac.DebugString("RNGControl loaded! RNG is now predictable per floor.")
