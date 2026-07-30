-- =============================================================================
--  PickupMagnetField — The Binding of Isaac: Repentance
--  All pickups in room slowly drift toward player at speed 0.5.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PickupMagnetField", 1)

local PULL_SPEED = 0.5

function mod:PullPickupsToPlayer()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    local playerPos = player.Position
    local entities = Isaac.GetRoomEntities()

    for i = 0, entities.Size - 1 do
        local entity = entities:Get(i)
        if entity.Type == EntityType.ENTITY_PICKUP then
            local pickup = entity:ToPickup()
            if pickup and not pickup:IsShopItem() then
                local pickupPos = pickup.Position
                local dir = (playerPos - pickupPos):Normalized()
                local distance = playerPos:Distance(pickupPos)

                if distance > 10 then
                    pickup.Velocity = dir * PULL_SPEED
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.PullPickupsToPlayer)
Isaac.DebugString("PickupMagnetField loaded!")
