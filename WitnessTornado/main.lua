-- ==========================================================================
--  Witness Tornado - The Binding of Isaac: Repentance
--  The Witness — tornado attacks pull nearby enemies into them.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("WitnessTornado", 1)

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == EntityType.ENTITY_MOTHER and npc.SubType == 0 then
        local room = Game():GetRoom()
        if not room then return end

        if npc.FrameCount % 120 == 0 then
            for i = 1, 2 do
                local tX = room:GetLeftWallPos() + math.random() * (room:GetRightWallPos() - room:GetLeftWallPos())
                local tY = room:GetTopLeftPos().Y + math.random() * (room:GetBottomRightPos().Y - room:GetTopLeftPos().Y)
                local tornadoPos = Vector(tX, tY)

                local entities = Isaac.GetRoomEntities()
                for _, ent in ipairs(entities) do
                    if ent:IsVulnerableEnemy() and ent.Index ~= npc.Index then
                        local dist = ent.Position:Distance(tornadoPos)
                        if dist < 150 and dist > 0 then
                            local pullDir = (tornadoPos - ent.Position):Normalized()
                            ent.Velocity = pullDir * (150 - dist) * 0.05
                        end
                    end
                end

                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WATER_SPLASH, 0,
                    tornadoPos, Vector.Zero, npc)
            end
        end
    end
end)

Isaac.DebugString("WitnessTornado loaded!")
