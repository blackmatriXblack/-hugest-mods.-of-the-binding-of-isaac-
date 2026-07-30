-- =============================================================================
--  TaintedMagdaleneBleed - The Binding of Isaac: Repentance
--  Tainted Magdalene: Red heart damage spawns temporary creep that damages enemies.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedMagdaleneBleed", 1)
local TAINTED_MAGDALENE = 22
local CREEP_VARIANT = EffectVariant.PLAYER_CREEP_RED
local CREEP_DURATION = 60 -- ~2 seconds

function mod:onEntityTakeDmg(target, amount, flags, source, countdown)
    if target.Type ~= EntityType.ENTITY_PLAYER then return end
    local player = target:ToPlayer()
    if not player or player:GetPlayerType() ~= TAINTED_MAGDALENE then return end

    -- Check if damage was to red hearts (DamageFlag 0 or red heart damage)
    if flags & DamageFlag.DAMAGE_RED_HEARTS == 0 and flags & DamageFlag.DAMAGE_NOKILL == 0 then
        -- Only trigger on red heart damage
        if amount <= 0 then return end
    end

    local pos = player.Position
    Isaac.Spawn(EntityType.ENTITY_EFFECT, CREEP_VARIANT, 0, pos, Vector.Zero, player):ToEffect()
    Isaac.DebugString("TaintedMagdaleneBleed: Creep spawned at player position.")
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
Isaac.DebugString("TaintedMagdaleneBleed loaded!")
