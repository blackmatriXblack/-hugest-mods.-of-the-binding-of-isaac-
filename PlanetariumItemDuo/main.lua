-- =============================================================================
--  PlanetariumItemDuo — The Binding of Isaac: Repentance
--  Planetariums always contain 2 planetarium items to choose from.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PlanetariumItemDuo", 1)

function mod:OnNewRoom()
    local level = Game():GetLevel()
    local room = level:GetCurrentRoom()
    local roomType = room:GetType()

    if roomType ~= RoomType.ROOM_PLANETARIUM then return end

    local entities = Isaac.GetRoomEntities()
    local pedestalCount = 0

    for _, ent in ipairs(entities) do
        if ent.Type == EntityType.ENTITY_PICKUP and
           ent.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            pedestalCount = pedestalCount + 1
            if pedestalCount == 1 then
                local pos = ent.Position + Vector(50, 0)
                Isaac.Spawn(
                    EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_COLLECTIBLE,
                    0,
                    pos,
                    Vector.Zero,
                    nil
                )
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)
Isaac.DebugString("PlanetariumItemDuo loaded!")
