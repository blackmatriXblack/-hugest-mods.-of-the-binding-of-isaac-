-- =============================================================================
--  OobRicochet -- The Binding of Isaac: Repentance
--  Oobs (Type=54) bounce off walls at increased speed.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("OobRicochet", 1)
local game = Game()

function mod:onNpcUpdate(npc)
    if npc.Type ~= 54 then return end
    local room = game:GetRoom()
    local pos = npc.Position
    local vel = npc.Velocity
    if pos.X <= room:GetTopLeftPos().X + 40 or pos.X >= room:GetBottomRightPos().X - 40 then
        vel = Vector(-vel.X * 1.5, vel.Y)
    end
    if pos.Y <= room:GetTopLeftPos().Y + 40 or pos.Y >= room:GetBottomRightPos().Y - 40 then
        vel = Vector(vel.X, -vel.Y * 1.5)
    end
    npc.Velocity = vel
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("OobRicochet loaded!")
