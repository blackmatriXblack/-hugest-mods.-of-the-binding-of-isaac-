-- =============================================================================
--  RoundWormTunnel — The Binding of Isaac: Repentance
--  Round Worms (Type=38) occasionally burrow and reappear elsewhere in the room.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RoundWormTunnel", 1)
local game = Game()

function mod:onNpcUpdate(npc)
    if npc.Type ~= 38 then return end
    if npc:GetData().tunnelCooldown and npc:GetData().tunnelCooldown > 0 then
        npc:GetData().tunnelCooldown = npc:GetData().tunnelCooldown - 1
        return
    end
    if math.random(1, 200) ~= 1 then return end
    local room = game:GetRoom()
    local pos = room:FindFreePickupSpawnPosition(npc.Position)
    if pos == nil then return end
    -- burrow out: teleport to new position
    npc.Position = pos
    npc.Velocity = Vector.Zero
    npc:GetData().tunnelCooldown = 60
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("RoundWormTunnel loaded!")
