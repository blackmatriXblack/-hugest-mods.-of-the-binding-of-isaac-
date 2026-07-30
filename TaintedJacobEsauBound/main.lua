-- =============================================================================
--  TaintedJacobEsauBound - The Binding of Isaac: Repentance
--  Tainted Jacob: Dark Esau deals 30% less damage to player.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedJacobEsauBound", 1)
local TAINTED_JACOB = 37
local DARK_ESAU = EntityType.ENTITY_DARK_ESAU
local DAMAGE_REDUCTION = 0.7 -- 30% less

function mod:onEntityTakeDmg(target, amount, flags, source, countdown)
    if target.Type ~= EntityType.ENTITY_PLAYER then return end
    if not source.Entity or source.Entity.Type ~= DARK_ESAU then return end

    local player = target:ToPlayer()
    if player and player:GetPlayerType() == TAINTED_JACOB then
        local newAmount = math.floor(amount * DAMAGE_REDUCTION)
        Isaac.DebugString("TaintedJacobEsauBound: Dark Esau damage reduced from " .. amount .. " to " .. newAmount)
        return newAmount
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
Isaac.DebugString("TaintedJacobEsauBound loaded!")
