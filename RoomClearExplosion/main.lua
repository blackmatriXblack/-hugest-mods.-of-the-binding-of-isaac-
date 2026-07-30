-- =============================================================================
--  RoomClearExplosion — The Binding of Isaac: Repentance
--  MC_PRE_ROOM_TRIGGER_CLEAR: Just before room clear triggers, all
--  remaining pickups teleport to center.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RoomClearExplosion", 1)

function mod:onPreRoomTriggerClear()
    local room = Game():GetRoom()
    if not room then return nil end

    local center = room:GetCenterPos()
    local entities = Isaac.GetRoomEntities()

    for _, entity in ipairs(entities) do
        if entity:Exists() and entity.Type == EntityType.ENTITY_PICKUP then
            -- Visual effect: small flash
            local effect = Isaac.Spawn(
                EntityType.ENTITY_EFFECT,
                EffectVariant.POOF01,
                0,
                entity.Position,
                Vector.Zero,
                nil
            )
            entity.Position = center
        end
    end

    return nil -- Allow room clear to proceed normally
end
mod:AddCallback(ModCallbacks.MC_PRE_ROOM_TRIGGER_CLEAR, mod.onPreRoomTriggerClear)

Isaac.DebugString("RoomClearExplosion loaded!")
