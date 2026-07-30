-- ==========================================================================
--  Tainted Monstro Rain - The Binding of Isaac: Repentance
--  Tainted Monstro — spit attack rains down across entire room.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TaintedMonstroRain", 1)
local MONSTRO_ID = EntityType.ENTITY_MONSTRO

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == MONSTRO_ID then
        local room = Game():GetRoom()
        local player = Isaac.GetPlayer(0)
        if not room or not player then return end

        if npc.FrameCount % 40 == 0 then
            for i = 1, 8 do
                local rainX = room:GetLeftWallPos() + (i / 8) * (room:GetRightWallPos() - room:GetLeftWallPos())
                local rainPos = Vector(rainX, room:GetTopLeftPos().Y - 20)
                Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0,
                    rainPos, Vector(0, 6), npc)
            end
        end
    end
end)

Isaac.DebugString("TaintedMonstroRain loaded!")
