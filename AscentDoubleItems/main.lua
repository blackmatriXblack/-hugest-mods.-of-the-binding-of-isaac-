-- =============================================================================
--  AscentDoubleItems — The Binding of Isaac: Repentance
--  During the Ascent, item pedestals come in pairs (pick one).
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("AscentDoubleItems", 1)

local ASCENT_STAGE = 26 -- Ascent stage type

function mod:OnNewRoom()
    local level = Game():GetLevel()
    local stage = level:GetStage()

    -- Check if we're on the Ascent
    if stage ~= ASCENT_STAGE then return end

    local room = level:GetCurrentRoom()
    local entities = Isaac.GetRoomEntities()

    for _, ent in ipairs(entities) do
        if ent.Type == EntityType.ENTITY_PICKUP and
           ent.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            -- Spawn a paired item pedestal nearby
            local pos = ent.Position + Vector(40, 0)
            local newPedestal = Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_COLLECTIBLE,
                0,
                pos,
                Vector.Zero,
                nil
            )
            if newPedestal then
                -- Make it a choice pedestal
                local newItem = newPedestal:ToPickup()
                if newItem then
                    newItem:GetSprite():Play("Appear")
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.OnNewRoom)
Isaac.DebugString("AscentDoubleItems loaded!")
