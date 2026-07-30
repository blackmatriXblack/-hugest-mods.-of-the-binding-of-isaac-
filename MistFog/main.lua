-- ==========================================================================
--  MistFog - The Binding of Isaac: Repentance
--  Mist enemy creates fog clouds that obscure player vision
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("MistFog", 1)
local game = Game()
local MIST_TYPE = EntityType.ENTITY_MIST

function mod:fogUpdate(_, npc)
    if npc.Type ~= MIST_TYPE then return end
    local player = game:GetPlayer(0)
    if not player then return end
    if npc.FrameCount % 60 == 0 then
        for i = 0, 2 do
            local offset = Vector(math.cos(i * 2.09) * 80, math.sin(i * 2.09) * 80)
            local fog = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 0, npc.Position + offset, Vector.Zero, npc)
            if fog then
                fog.SpriteScale = Vector(2, 2)
                fog:GetSprite().Color = Color(0.7, 0.7, 0.8, 0.4, 0, 0, 0)
            end
        end
        if npc.Position:Distance(player.Position) < 150 then
            player:AddDarkness(npc.InitSeed, 60)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.fogUpdate, MIST_TYPE)
Isaac.DebugString("MistFog loaded!")
