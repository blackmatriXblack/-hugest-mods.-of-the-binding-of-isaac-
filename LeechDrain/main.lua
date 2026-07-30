-- =============================================================================
--  LeechDrain -- The Binding of Isaac: Repentance
--  Leeches (Type=47) drain 1 full heart on contact instead of half.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("LeechDrain", 1)

function mod:onEntityTakeDmg(target, amount, flag, source, countdown)
    if source.Entity == nil then return end
    if source.Entity.Type ~= 47 then return end
    if flag & DamageFlag.DAMAGE_CONTACT ~= 0 then
        return 2 -- deal 1 full heart (2 half-hearts)
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
Isaac.DebugString("LeechDrain loaded!")
