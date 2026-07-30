-- ==========================================================================
--  Ultra Pestilence Plague - The Binding of Isaac: Repentance
--  Ultra Pestilence's plague clouds spread 2x faster.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("UltraPestilencePlague", 1)
local PESTILENCE_ID = EntityType.ENTITY_PESTILENCE

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == PESTILENCE_ID then
        local room = Game():GetRoom()
        if not room then return end

        if npc.FrameCount % 30 == 0 then
            local entities = Isaac.GetRoomEntities()
            for _, ent in ipairs(entities) do
                if ent.Type == EntityType.ENTITY_EFFECT and
                   ent.Variant == EffectVariant.POISON_CLOUD then
                    ent.Velocity = ent.Velocity * 1.3
                    ent.SpriteScale = Vector(2.0, 2.0)
                end
            end

            local player = Isaac.GetPlayer(0)
            if player then
                for i = 1, 3 do
                    local dir = Vector.FromAngle(math.random() * math.pi * 2)
                    local cloudPos = npc.Position + dir * 80
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POISON_CLOUD, 0,
                        cloudPos, dir * 5, npc)
                end
            end
        end
    end
end)

Isaac.DebugString("UltraPestilencePlague loaded!")
