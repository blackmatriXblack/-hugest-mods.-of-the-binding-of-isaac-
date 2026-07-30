-- =============================================================================
--  SquirtAcidPool -- The Binding of Isaac: Repentance
--  Squirts (Type=52) create larger creep pools that last 3x longer.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SquirtAcidPool", 1)

function mod:onEntitySpawn(entity)
    if entity.Type ~= EntityType.ENTITY_EFFECT then return end
    if entity.Variant ~= EffectVariant.PLAYER_CREEP_RED then return end
    entity.SizeMulti = entity.SizeMulti * 2.0
    entity:SetTimeout(entity:GetTimeout() * 3)
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onEntitySpawn)
Isaac.DebugString("SquirtAcidPool loaded!")
