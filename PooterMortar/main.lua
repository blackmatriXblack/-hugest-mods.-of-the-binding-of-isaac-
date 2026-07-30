-- =============================================================================
--  PooterMortar — The Binding of Isaac: Repentance
--  Pooters (Type=2) shoot in 3-way spread instead of single shot.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PooterMortar", 1)
local pooterTimers = {}

function mod:onNPCUpdate(npc)
    if npc.Type ~= 2 then return end
    if npc.State ~= NpcState.STATE_ATTACK then return end

    local idx = GetPtrHash(npc)
    pooterTimers[idx] = (pooterTimers[idx] or 0) + 1

    if pooterTimers[idx] >= 30 then
        pooterTimers[idx] = 0
        local player = Isaac.GetPlayer(0)
        if player then
            local dir = (player.Position - npc.Position):Normalized()
            local angles = {-0.3, 0, 0.3}
            for _, a in ipairs(angles) do
                local spreadDir = dir:Rotated(a)
                local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, npc.Position, spreadDir * 4, npc)
                if tear then
                    tear:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
Isaac.DebugString("PooterMortar loaded!")
