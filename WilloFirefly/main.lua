-- ==========================================================================
--  WilloFirefly - The Binding of Isaac: Repentance
--  Willo firefly lights up dark rooms and explodes on death
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("WilloFirefly", 1)
local game = Game()
local WILLO_TYPE = EntityType.ENTITY_WILLO

function mod:willoUpdate(_, npc)
    if npc.Type ~= WILLO_TYPE then return end
    local player = game:GetPlayer(0)
    if not player then return end
    if npc.FrameCount % 10 == 0 then
        local light = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALO, 0, npc.Position, Vector.Zero, npc)
        if light then
            light.SpriteScale = Vector(1.5, 1.5)
            light:GetSprite().Color = Color(1, 1, 0.4, 0.6, 0, 0, 0)
            if npc.Position:Distance(player.Position) < 100 then
                player:AddDarkness(npc.InitSeed, -1)
            end
        end
    end
end

function mod:willoDeath(_, npc)
    if npc.Type ~= WILLO_TYPE then return end
    Isaac.Explode(npc.Position, npc, 40)
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.willoUpdate, WILLO_TYPE)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.willoDeath, WILLO_TYPE)
Isaac.DebugString("WilloFirefly loaded!")
