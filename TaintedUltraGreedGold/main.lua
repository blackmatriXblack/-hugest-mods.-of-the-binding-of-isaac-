-- ==========================================================================
--  Tainted Ultra Greed Gold - The Binding of Isaac: Repentance
--  Tainted Ultra Greed — coin drops explode on contact with player.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TaintedUltraGreedGold", 1)

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == EntityType.ENTITY_ULTRA_GREED then
        local room = Game():GetRoom()
        local player = Isaac.GetPlayer(0)
        if not room or not player then return end

        local entities = Isaac.GetRoomEntities()
        for _, ent in ipairs(entities) do
            if ent.Type == EntityType.ENTITY_PICKUP and
               ent.Variant == PickupVariant.PICKUP_COIN then
                local dist = player.Position:Distance(ent.Position)
                if dist < 30 then
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0,
                        ent.Position, Vector.Zero, nil)
                    ent:Remove()
                end
            end
        end
    end
end)

Isaac.DebugString("TaintedUltraGreedGold loaded!")
