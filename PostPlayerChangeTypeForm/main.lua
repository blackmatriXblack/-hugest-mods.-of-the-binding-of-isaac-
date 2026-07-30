-- =============================================================================
--  PostPlayerChangeTypeForm - The Binding of Isaac: Repentance
--  3 seconds of invincibility when character type changes (reroll, revive).
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PostPlayerChangeTypeForm", 1)

function mod:onPostPlayerChangeType(player, oldType, newType)
    if oldType == newType then return end
    -- Grant 3 seconds (90 frames) of invincibility via EntityEffect
    local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_TELEPORT, 0, player.Position, Vector.Zero, player)
    -- Add brief invincibility by giving player the "emperors clothes" effect via GetEffects
    player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_CELTIC_CROSS, true, 90)
    Isaac.DebugString("Type changed! 3 seconds invincibility granted.")
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_CHANGE_TYPE, mod.onPostPlayerChangeType)
Isaac.DebugString("PostPlayerChangeTypeForm loaded!")
