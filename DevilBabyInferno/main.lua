-- =============================================================================
--  DevilBabyInferno — The Binding of Isaac: Repentance
--  Devil Babies (Type=41) shoot brimstone lasers when enraged.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DevilBabyInferno", 1)
local game = Game()

function mod:onNpcUpdate(npc)
    if npc.Type ~= 41 then return end
    if npc.FrameCount % 120 ~= 0 then return end
    local player = Isaac.GetPlayer(0)
    if not player then return end
    local dir = (player.Position - npc.Position):Normalized()
    local brim = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0,
        npc.Position, dir * 8, npc)
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("DevilBabyInferno loaded!")
