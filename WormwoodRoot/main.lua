-- ==========================================================================
--  Wormwood Root - The Binding of Isaac: Repentance
--  Wormwood roots go 50% deeper and surface at 3 random positions.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("WormwoodRoot", 1)

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == EntityType.ENTITY_WORMWOOD then
        local room = Game():GetRoom()
        local player = Isaac.GetPlayer(0)
        if not room or not player then return end

        if npc.FrameCount % 70 == 0 then
            for i = 1, 3 do
                local width = room:GetRightWallPos() - room:GetLeftWallPos()
                local height = room:GetBottomRightPos().Y - room:GetTopLeftPos().Y
                local offsetX = (math.random() - 0.5) * width * 1.5
                local offsetY = (math.random() - 0.5) * height * 1.5
                local rootPos = player.Position + Vector(offsetX, offsetY)

                rootPos.X = math.max(room:GetLeftWallPos(), math.min(room:GetRightWallPos(), rootPos.X))
                rootPos.Y = math.max(room:GetTopLeftPos().Y, math.min(room:GetBottomRightPos().Y, rootPos.Y))

                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0,
                    rootPos, Vector(0, -10), npc)
            end
        end
    end
end)

Isaac.DebugString("WormwoodRoot loaded!")
