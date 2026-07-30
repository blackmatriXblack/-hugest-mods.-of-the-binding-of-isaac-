-- ==========================================================================
--  Tainted Gurdy Cannon - The Binding of Isaac: Repentance
--  Tainted Gurdy — gains a brimstone cannon rotating around the room.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TaintedGurdyCannon", 1)
local GURDY_ID = EntityType.ENTITY_GURDY
local cannon_angle = 0

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == GURDY_ID then
        local room = Game():GetRoom()
        local player = Isaac.GetPlayer(0)
        if not room or not player then return end

        cannon_angle = cannon_angle + 0.03
        local roomCenter = room:GetCenterPos()
        local cannonPos = roomCenter + Vector.FromAngle(cannon_angle) * 120

        if npc.FrameCount % 30 == 0 then
            local dirToCenter = (roomCenter - cannonPos):Normalized()
            Isaac.Spawn(EntityType.ENTITY_LASER, 0, 0,
                cannonPos, dirToCenter * 20, npc)
        end
    end
end)

Isaac.DebugString("TaintedGurdyCannon loaded!")
