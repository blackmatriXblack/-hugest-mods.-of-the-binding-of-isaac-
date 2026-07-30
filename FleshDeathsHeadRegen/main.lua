-- ==========================================================================
--  FleshDeathsHeadRegen - The Binding of Isaac: Repentance
--  Flesh Death's Head regenerates 5% HP per second
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("FleshDeathsHeadRegen", 1)
local game = Game()
local DEATHS_HEAD_TYPE = EntityType.ENTITY_DEATHS_HEAD
local FLESH_VARIANT = 2

function mod:regenUpdate(_, npc)
    if npc.Type ~= DEATHS_HEAD_TYPE or npc.Variant ~= FLESH_VARIANT then return end
    if npc.FrameCount % 30 == 0 and npc.HitPoints < npc.MaxHitPoints then
        local regenAmount = math.ceil(npc.MaxHitPoints * 0.05)
        npc.HitPoints = math.min(npc.HitPoints + regenAmount, npc.MaxHitPoints)
        -- Visual feedback
        local heal = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HEART, 0, npc.Position, Vector(0, -1), npc)
        if heal then
            heal:GetSprite().Color = Color(0.5, 1, 0.3, 0.8, 0, 0, 0)
            heal.SpriteScale = Vector(0.5, 0.5)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.regenUpdate, DEATHS_HEAD_TYPE)
Isaac.DebugString("FleshDeathsHeadRegen loaded!")
