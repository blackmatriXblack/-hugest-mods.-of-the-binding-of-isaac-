-- SpectralPiercingTears: Applies spectral and piercing tear flags to player
local mod = RegisterMod("SpectralPiercingTears", 1)

function mod:onPEffectUpdate(player)
    player:AddTearFlags(1)
    player:AddTearFlags(2)
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
Isaac.DebugString("SpectralPiercingTears loaded! Tears are spectral and piercing.")
