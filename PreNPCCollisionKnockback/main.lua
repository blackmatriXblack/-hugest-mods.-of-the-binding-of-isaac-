-- =============================================================================
--  PreNPCCollisionKnockback - The Binding of Isaac: Repentance
--  NPC contact damage pushes player away before damage resolves.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PreNPCCollisionKnockback", 1)

function mod:onPreNPCCollision(npc, player, low)
    if player:IsDead() then return end
    -- Push player away from NPC before collision damage resolves
    local dir = (player.Position - npc.Position):Normalized()
    local knockVel = dir * 8
    player.Velocity = player.Velocity + knockVel
    -- Brief invincibility frames to not double-dip
    player:AddEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK, 15)
end

mod:AddCallback(ModCallbacks.MC_PRE_NPC_COLLISION, mod.onPreNPCCollision)
Isaac.DebugString("PreNPCCollisionKnockback loaded!")
