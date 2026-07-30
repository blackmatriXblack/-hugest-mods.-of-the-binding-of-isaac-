-- DevilAngelGuarantee: Guarantees Devil/Angel room spawn on every floor
local mod = RegisterMod("DevilAngelGuarantee", 1)

function mod:onNewLevel()
    local level = Game():GetLevel()
    level:SetStateFlag(1)
    Isaac.DebugString("DevilAngelGuarantee: Devil/Angel room guaranteed!")
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
Isaac.DebugString("DevilAngelGuarantee loaded! Devil/Angel rooms always spawn.")
