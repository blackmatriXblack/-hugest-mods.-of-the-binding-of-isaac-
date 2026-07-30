-- =============================================================================
--  TriteJumpScare -- The Binding of Isaac: Repentance
--  Trites (Type=46) jump 2x higher and faster, deal contact damage mid-air.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TriteJumpScare", 1)

function mod:onNpcUpdate(npc)
    if npc.Type ~= 46 then return end
    npc.Velocity = npc.Velocity * 1.3
    if not npc:IsFlying() then
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("TriteJumpScare loaded!")
