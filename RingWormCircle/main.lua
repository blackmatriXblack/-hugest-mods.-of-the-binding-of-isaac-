-- =============================================================================
--  RingWormCircle — The Binding of Isaac: Repentance
--  Ring Worms (Type=245) spin in a perfect circle around the room center.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RingWormCircle", 1)
local game = Game()
local BASE_SPEED = 2.5
local CIRCLE_RADIUS = 120

function mod:onNpcUpdate(npc)
    if npc.Type ~= 245 then return end
    local room = game:GetRoom()
    local center = room:GetCenterPos()
    local angle = npc.FrameCount * 0.03
    local targetX = center.X + math.cos(angle) * CIRCLE_RADIUS
    local targetY = center.Y + math.sin(angle) * CIRCLE_RADIUS
    local target = Vector(targetX, targetY)
    npc.Velocity = (target - npc.Position):Normalized() * BASE_SPEED
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("RingWormCircle loaded!")
