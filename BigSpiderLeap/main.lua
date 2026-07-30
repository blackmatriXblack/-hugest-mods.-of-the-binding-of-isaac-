-- =============================================================================
--  BigSpiderLeap — The Binding of Isaac: Repentance
--  Big Spiders (Type=43) leap toward player when within 150 distance.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BigSpiderLeap", 1)
local leapCooldown = {}

function mod:onNPCUpdate(npc)
    if npc.Type ~= 43 then return end

    local idx = GetPtrHash(npc)
    leapCooldown[idx] = (leapCooldown[idx] or 0) - 1

    local player = Isaac.GetPlayer(0)
    if not player then return end

    local dist = (player.Position - npc.Position):Length()
    if dist <= 150 and leapCooldown[idx] <= 0 then
        leapCooldown[idx] = 60
        local dir = (player.Position - npc.Position):Normalized()
        npc.Velocity = dir * 8
        npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
Isaac.DebugString("BigSpiderLeap loaded!")
