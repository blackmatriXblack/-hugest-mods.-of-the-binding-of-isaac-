-- =============================================================================
--  KnightGuardShield — The Binding of Isaac: Repentance
--  Knights (Type=17) take 80% reduced damage from the front.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("KnightGuardShield", 1)

local SHIELD_ANGLE = 70   -- Half-angle of the shielded front arc in degrees
local DAMAGE_REDUCTION = 0.8

function mod:onEntityTakeDmg(target, damageAmount, damageFlag, damageSource, countdown)
    if target.Type ~= 17 then return nil end

    -- Only reduce if damage comes from the front
    if damageSource.Entity and damageSource.Entity == Isaac.GetPlayer(0) then
        local player = Isaac.GetPlayer(0)
        local toTarget = (target.Position - player.Position):Normalized()
        local forward = Vector(0, -1):Rotated(target.Angle or 0)
        -- In Isaac, enemies face downwards by default
        local dot = toTarget.X * forward.X + toTarget.Y * forward.Y
        local angleRad = math.acos(math.min(1, math.max(-1, dot)))
        local angleDeg = math.deg(angleRad)

        if angleDeg < SHIELD_ANGLE then
            local newDmg = damageAmount * (1 - DAMAGE_REDUCTION)
            target:TakeDamage(newDmg, damageFlag, damageSource, countdown)
            return false -- Prevent original full damage
        end
    end

    return nil
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
Isaac.DebugString("KnightGuardShield loaded!")
