-- ==========================================================================
--  HushGaperScream - The Binding of Isaac: Repentance
--  Hush's blue Gapers scream periodically stunning player in 100px range
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("HushGaperScream", 1)
local game = Game()
local GAPER_TYPE = EntityType.ENTITY_GAPER
local HUSH_VARIANT = 3

function mod:screamUpdate(_, npc)
    if npc.Type ~= GAPER_TYPE or npc.Variant ~= HUSH_VARIANT then return end
    local player = game:GetPlayer(0)
    if not player then return end
    if npc.FrameCount % 180 == 0 and npc.Position:Distance(player.Position) < 100 then
        npc:PlaySound(SoundEffect.SOUND_MEGA_BLAST, 1, 0, false, 1)
        player:AddControlsCooldown(20)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.RING_OF_LIFE, 0, npc.Position, Vector.Zero, npc)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.screamUpdate, GAPER_TYPE)
Isaac.DebugString("HushGaperScream loaded!")
