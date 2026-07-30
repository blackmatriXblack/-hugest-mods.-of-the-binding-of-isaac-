local mod = RegisterMod("TearSizeBooster", 1)

function mod:onPeffectUpdate(player, flags)
    player.TearScale = 3
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPeffectUpdate)
