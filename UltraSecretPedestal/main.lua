-- =============================================================================
--  UltraSecretPedestal — The Binding of Isaac: Repentance
--  Ultra secret rooms always contain 1 angel item pedestal in addition to red item.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("UltraSecretPedestal", 1)

function mod:OnNewRoom()
    local level = Game():GetLevel()
    local room = level:GetCurrentRoom()
    local roomType = room:GetType()

    if roomType ~= RoomType.ROOM_ULTRA_SECRET then return end

    local entities = Isaac.GetRoomEntities()
    local hasRedItem = false
    local spawnPos = room:GetCenterPos()

    for _, ent in ipairs(entities) do
        if ent.Type == EntityType.ENTITY_PICKUP and
           ent.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            hasRedItem = true
            spawnPos = ent.Position + Vector(50, 0)
            break
        end
    end

    if hasRedItem then
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            0,
            spawnPos,
            Vector.Zero,
            nil
        )
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)
Isaac.DebugString("UltraSecretPedestal loaded!")
