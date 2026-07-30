-- ==========================================================================
--  AttackFlyLevel2Shield - The Binding of Isaac: Repentance
--  Level 2 Attack Fly has an orbiting shield that blocks 1 hit
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("AttackFlyLevel2Shield", 1)
local game = Game()
local ATTACK_FLY_TYPE = EntityType.ENTITY_ATTACK_FLY
local shieldActive = {}

function mod:shieldUpdate(_, npc)
    if npc.Type ~= ATTACK_FLY_TYPE or npc.Variant ~= 2 then return end
    local idx = GetPtrHash(npc)
    if shieldActive[idx] == nil then shieldActive[idx] = true end
    if shieldActive[idx] then
        npc:AddEntityFlags(EntityFlag.FLAG_INVINCIBLE)
        if npc.HitPoints < npc.MaxHitPoints then
            shieldActive[idx] = false
            npc:ClearEntityFlags(EntityFlag.FLAG_INVINCIBLE)
            npc:TakeDamage(0, 0, EntityRef(npc), 0)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0, npc.Position, Vector.Zero, npc)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.shieldUpdate, ATTACK_FLY_TYPE)
Isaac.DebugString("AttackFlyLevel2Shield loaded!")
