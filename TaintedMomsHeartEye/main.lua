-- ==========================================================================
--  Tainted Mom's Heart Eye - The Binding of Isaac: Repentance
--  Tainted Mom's Heart — eye laser sweeps 360 degrees continuously.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TaintedMomsHeartEye", 1)
local HEART_ID = EntityType.ENTITY_MOMS_HEART
local laser_angle = 0

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == HEART_ID then
        local room = Game():GetRoom()
        if not room then return end

        laser_angle = (laser_angle + 1.5) % 360

        if npc.FrameCount % 3 == 0 then
            local rad = laser_angle * math.pi / 180
            local dir = Vector.FromAngle(rad)
            Isaac.Spawn(EntityType.ENTITY_LASER, 0, 0,
                npc.Position, dir * 15, npc)
        end
    end
end)

Isaac.DebugString("TaintedMomsHeartEye loaded!")
