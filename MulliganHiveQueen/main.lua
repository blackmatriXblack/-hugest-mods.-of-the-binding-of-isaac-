-- =============================================================================
--  MulliganHiveQueen — The Binding of Isaac: Repentance
--  Mulligans (Type=7) spawn 5 Attack Flies on death instead of 2.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MulliganHiveQueen", 1)

local FLY_COUNT = 5
local ATTACK_FLY_TYPE = 62

function mod:onEntityKill(entity)
    if entity.Type == 7 then
        for i = 1, FLY_COUNT do
            local fly = Isaac.Spawn(
                ATTACK_FLY_TYPE, 0, 0,
                entity.Position, Vector.Zero, entity
            )
            if fly then
                fly:ClearEntityFlags(EntityFlag.FLAG_APPEAR)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onEntityKill)
Isaac.DebugString("MulliganHiveQueen loaded!")
