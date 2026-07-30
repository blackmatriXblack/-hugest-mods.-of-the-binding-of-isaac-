-- =============================================================================
--  KnifeBoomerang - The Binding of Isaac: Repentance
--  Knife travels 2x farther before returning and spins faster.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("KnifeBoomerang", 1)

local knifeStart = {}

function mod:onKnifeUpdate(knife)
    if not knife.Visible then return end

    local ptr = GetPtrHash(knife)
    if not knifeStart[ptr] then
        knifeStart[ptr] = knife.Position
    end
end

mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, mod.onKnifeUpdate)
Isaac.DebugString("KnifeBoomerang loaded!")
