-- =============================================================================
--  ParaBiteLeech — The Binding of Isaac: Repentance
--  Para-Bites (Type=52, Variant=1) heal from tear hits instead of taking damage.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ParaBiteLeech", 1)

function mod:onEntityTakeDmg(target, amount, flag, source, countdown)
    if target.Type ~= 52 or target.Variant ~= 1 then return end
    if flag & DamageFlag.DAMAGE_TEAR ~= 0 then
        target:AddHealth(amount * 2)
        return false -- prevent damage
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
Isaac.DebugString("ParaBiteLeech loaded!")
