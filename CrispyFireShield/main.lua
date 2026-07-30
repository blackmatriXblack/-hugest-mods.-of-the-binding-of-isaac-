-- ==========================================================================
--  CrispyFireShield - The Binding of Isaac: Repentance
--  Crispy enemy has rotating fire shield and is immune to fire tears
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("CrispyFireShield", 1)
local game = Game()
local CRISPY_TYPE = EntityType.ENTITY_CRISPY

function mod:shieldUpdate(_, npc)
    if npc.Type ~= CRISPY_TYPE then return end
    local angle = (npc.FrameCount % 360) * math.pi / 180
    local firePos = npc.Position + Vector(math.cos(angle) * 40, math.sin(angle) * 40)
    local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 0, firePos, Vector.Zero, npc)
    if fire then
        fire.SpriteScale = Vector(0.6, 0.6)
        fire.Parent = npc
    end
end

function mod:fireImmunity(_, tookDamage, damageAmount, damageFlag, damageSource, damageCountdown)
    if tookDamage ~= CRISPY_TYPE then return end
    local npc = tookDamage:ToNPC()
    if not npc then return end
    if damageFlag & DamageFlag.DAMAGE_FIRE == DamageFlag.DAMAGE_FIRE then
        return false
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.shieldUpdate, CRISPY_TYPE)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.fireImmunity)
Isaac.DebugString("CrispyFireShield loaded!")
