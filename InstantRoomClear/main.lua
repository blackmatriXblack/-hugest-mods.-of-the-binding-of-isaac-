-- =============================================================================
--  INSTANT ROOM CLEAR — The Binding of Isaac: Repentance
--  Kills all non-boss enemies immediately upon entering any room.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("InstantRoomClear", 1)

function mod:onNewRoom()
    local entities = Isaac.GetRoomEntities()
    if entities == nil then return end

    for _, entity in ipairs(entities) do
        if entity:IsVulnerableEnemy() and not entity:IsBoss() then
            entity:Kill()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("Instant Room Clear loaded!")
