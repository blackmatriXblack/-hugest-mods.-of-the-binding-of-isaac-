-- =============================================================================
--  BabyRage — The Binding of Isaac: Repentance
--  Babies (Type=40) transform into Devil Baby (Type=41) when damaged below 50% HP.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BabyRage", 1)

function mod:onEntityTakeDmg(target, amount, flag, source, countdown)
    if target.Type ~= 40 then return end
    if target:GetData().transformed then return end
    local hpPercent = target.HitPoints / target.MaxHitPoints
    if hpPercent < 0.5 then
        target:GetData().transformed = true
        -- morph to Devil Baby: respawn as Type 41 at same position
        local pos = target.Position
        target:Kill()
        local devil = Isaac.Spawn(EntityType.ENTITY_BABY, 41, 0, pos, Vector.Zero, nil)
        if devil then
            devil.HitPoints = target.MaxHitPoints * 0.5
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
Isaac.DebugString("BabyRage loaded!")
