-- =============================================================================
--  SuckerVampire — The Binding of Isaac: Repentance
--  Suckers (Type=64) heal 50% of damage dealt.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SuckerVampire", 1)

function mod:onTakeDmg(target, amount, flags, source, countdown)
    if source and source.Type == 64 then
        local heal = amount * 0.5
        source.HitPoints = math.min(source.HitPoints + heal, source.MaxHitPoints)
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onTakeDmg)
Isaac.DebugString("SuckerVampire loaded!")
