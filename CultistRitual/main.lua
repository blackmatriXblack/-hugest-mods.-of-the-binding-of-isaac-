-- ==========================================================================
--  CultistRitual - The Binding of Isaac: Repentance
--  Cultist casts rituals buffing nearby enemies with +20% damage
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("CultistRitual", 1)
local game = Game()
local CULTIST_TYPE = EntityType.ENTITY_CULTIST

function mod:ritualUpdate(_, npc)
    if npc.Type ~= CULTIST_TYPE then return end
    if npc.FrameCount % 200 == 0 then
        local ents = Isaac.GetRoomEntities()
        for _, ent in ipairs(ents) do
            local enemy = ent:ToNPC()
            if enemy and ent.Type ~= CULTIST_TYPE and npc.Position:Distance(ent.Position) < 200 then
                enemy.Size = enemy.Size * 1.15
                enemy:AddEntityFlags(EntityFlag.FLAG_ENRAGED)
                local halo = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALO, 0, ent.Position, Vector.Zero, npc)
                if halo then halo:GetSprite().Color = Color(1, 0.2, 0.2, 0.5, 0, 0, 0) end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.ritualUpdate, CULTIST_TYPE)
Isaac.DebugString("CultistRitual loaded!")
