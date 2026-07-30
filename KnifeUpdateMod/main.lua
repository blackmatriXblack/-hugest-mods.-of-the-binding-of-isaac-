local mod = RegisterMod("KnifeUpdateMod", 1)

function mod:onKnifeUpdate(knife)
    if knife:Exists() then
        knife:AddEntityFlags(EntityFlag.FLAG_SLOW)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, mod.onKnifeUpdate)
