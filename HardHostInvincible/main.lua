-- ==========================================================================
--  HardHostInvincible - The Binding of Isaac: Repentance
--  Hard Host is completely invincible when skull is closed taking zero damage
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("HardHostInvincible", 1)
local game = Game()
local HOST_TYPE = EntityType.ENTITY_HOST
local HARD_VARIANT = 2

function mod:invincibleDamage(_, tookDamage, damageAmount, damageFlag, damageSource, damageCountdown)
    if tookDamage.Type ~= HOST_TYPE then return end
    local npc = tookDamage:ToNPC()
    if not npc or npc.Variant ~= HARD_VARIANT then return end
    -- If skull is closed (State == 0), negate all damage
    if npc.State == 0 then
        npc:PlaySound(SoundEffect.SOUND_ROCK_CRUMBLE, 1, 0, false, 1)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0, npc.Position, Vector.Zero, npc)
        return false
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.invincibleDamage)
Isaac.DebugString("HardHostInvincible loaded!")
