-- ==========================================================================
--  Mega Satan Hand Right - The Binding of Isaac: Repentance
--  Mega Satan's right hand creates brimstone lasers from ground up.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("MegaSatanHandRight", 1)

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == EntityType.ENTITY_MEGA_SATAN then
        local room = Game():GetRoom()
        local player = Isaac.GetPlayer(0)
        if not room or not player then return end

        if npc.FrameCount % 100 == 0 then
            for i = 1, 5 do
                local laserX = player.Position.X + (i - 3) * 60
                local groundPos = Vector(laserX, room:GetBottomRightPos().Y - 40)
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0,
                    groundPos, Vector.Zero, npc)
            end
        end
    end
end)

Isaac.DebugString("MegaSatanHandRight loaded!")
