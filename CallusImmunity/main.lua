-- =============================================================================
--  CallusImmunity - The Binding of Isaac: Repentance
--  Callus trinket grants immunity to ALL floor hazards (spikes, creep, fire)
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CallusImmunity", 1)
local TRINKET_CALLUS = 17

function mod:onPlayerUpdate(player)
    if not player:HasTrinket(TRINKET_CALLUS) then return end

    -- Grant creep immunity (red creep, black creep, white creep)
    if not player:HasEntityFlags(EntityFlag.FLAG_NO_TARGET) then
        player:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
        player:AddEntityFlags(EntityFlag.FLAG_NO_STATUS_EFFECTS)
    end
end

function mod:onPlayerDamage(target, damageAmount, damageFlag, damageSource, damageCountdownFrames)
    local player = target:ToPlayer()
    if not player or not player:HasTrinket(TRINKET_CALLUS) then return end

    -- Block damage from spikes, creep, and fire
    if damageFlag == DamageFlag.DAMAGE_SPIKES
        or damageFlag == DamageFlag.DAMAGE_CREEP
        or damageFlag == DamageFlag.DAMAGE_FIRE then
        return false
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onPlayerDamage)
Isaac.DebugString("CallusImmunity loaded!")
