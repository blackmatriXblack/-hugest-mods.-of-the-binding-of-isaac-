local mod = RegisterMod("TearColorRandomizer", 1)
local rng = RNG()

function mod:onPeffectUpdate(player, flags)
    local color = Color(rng:RandomFloat(), rng:RandomFloat(), rng:RandomFloat(), 1, rng:RandomFloat(), rng:RandomFloat(), rng:RandomFloat())
    player.TearColor = color
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPeffectUpdate)
