-- ==========================================================================
--  MegaGaperCrush - The Binding of Isaac: Repentance
--  Mega Gaper crushes into ground creating shockwave damage
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("MegaGaperCrush", 1)
local game = Game()
local MEGA_GAPER_TYPE = EntityType.ENTITY_GAPER
local MEGA_GAPER_VARIANT = 2 -- Mega Gaper variant

function mod:crushUpdate(_, npc)
    if npc.Type ~= MEGA_GAPER_TYPE or npc.Variant ~= MEGA_GAPER_VARIANT then return end
    local player = game:GetPlayer(0)
    if not player then return end
    local dist = npc.Position:Distance(player.Position)
    if dist < 120 and npc.FrameCount % 90 == 0 then
        -- Crush animation and shockwave
        npc:PlaySound(SoundEffect.SOUND_EARTHQUAKE, 1, 0, false, 1)
        local shockwave = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0, npc.Position, Vector.Zero, npc)
        -- Damage all entities in radius
        local ents = Isaac.GetRoomEntities()
        for _, ent in ipairs(ents) do
            if ent:ToPlayer() and npc.Position:Distance(ent.Position) < 80 then
                ent:TakeDamage(2, DamageFlag.DAMAGE_NOKILL, EntityRef(npc), 0)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.crushUpdate, MEGA_GAPER_TYPE)
Isaac.DebugString("MegaGaperCrush loaded!")
