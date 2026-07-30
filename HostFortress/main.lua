-- =============================================================================
--  HostFortress — The Binding of Isaac: Repentance
--  Hosts (Type=15) gain +50% damage resistance while skull is down.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("HostFortress", 1)

-- Host states: typically State 0 = skull up (vulnerable), State 1+ = skull down
local INVULN_STATES = { 1, 2, 3 }

function mod:onEntityTakeDmg(target, damageAmount, damageFlag, damageSource, countdown)
    if target.Type ~= 15 then return nil end

    local state = target.State
    for _, invulnState in ipairs(INVULN_STATES) do
        if state == invulnState then
            -- Block 50% of the damage (deal half damage)
            local newDmg = damageAmount * 0.5
            -- Apply reduced damage
            target:TakeDamage(newDmg, damageFlag, damageSource, countdown)
            return false -- Prevent original damage
        end
    end

    return nil -- Use default behavior
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
Isaac.DebugString("HostFortress loaded!")
