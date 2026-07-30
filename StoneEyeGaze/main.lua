-- =============================================================================
--  StoneEyeGaze -- The Binding of Isaac: Repentance
--  Stone Eyes (Type=69) fire brimstone laser that follows player slowly.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("StoneEyeGaze", 1)
local game = Game()

function mod:onNpcUpdate(npc)
    if npc.Type ~= 69 then return end
    if npc.FrameCount % 90 ~= 0 then return end
    local player = Isaac.GetPlayer(0)
    if not player then return end
    local dir = (player.Position - npc.Position):Normalized()
    local laser = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0,
        npc.Position, dir * 4, npc)
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("StoneEyeGaze loaded!")
