-- =============================================================================
--  Stone Chest Party - The Binding of Isaac: Repentance
--  All stone chests become glorious golden chests!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("StoneChestParty", 1)

function mod:onEntitySpawn(entity)
    if entity.Type ~= EntityType.ENTITY_PICKUP then return end

    local variant = entity.Variant
    -- Convert stone chests and their variants to golden chests
    if variant == PickupVariant.PICKUP_STONECHEST or
       variant == PickupVariant.PICKUP_BOMBCHEST then

        -- Morph into golden chest (closed)
        entity:Morph(EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_CHEST,
            ChestSubType.CHEST_GOLDEN,
            true, true)

        -- Golden sparkle effect
        entity:GetSprite().Color = Color(1, 0.85, 0.2, 1, 0.3, 0.3, 0)
        entity:GetSprite().PlaybackSpeed = 1.2

        Isaac.DebugString("Stone chest turned GOLDEN!")
    elseif variant == PickupVariant.PICKUP_LOCKEDCHEST then
        -- Locked chests become golden too
        entity:Morph(EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_CHEST,
            ChestSubType.CHEST_GOLDEN,
            true, true)
        entity:GetSprite().Color = Color(1, 0.85, 0.2, 1, 0.3, 0.3, 0)
        Isaac.DebugString("Locked chest turned GOLDEN!")
    elseif variant == PickupVariant.PICKUP_OLDCHEST then
        -- Old chests become golden
        entity:Morph(EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_CHEST,
            ChestSubType.CHEST_GOLDEN,
            true, true)
        entity:GetSprite().Color = Color(1, 0.85, 0.2, 1, 0.3, 0.3, 0)
        Isaac.DebugString("Old chest turned GOLDEN!")
    end
end

function mod:onNewRoom()
    -- Re-check all entities in the room for any missed conversions
    local entities = Isaac.GetRoomEntities()
    for _, entity in ipairs(entities) do
        if entity:Exists() and entity.Type == EntityType.ENTITY_PICKUP then
            local v = entity.Variant
            if v == PickupVariant.PICKUP_STONECHEST or
               v == PickupVariant.PICKUP_BOMBCHEST then
                entity:Morph(EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_CHEST,
                    ChestSubType.CHEST_GOLDEN,
                    true, true)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onEntitySpawn)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("StoneChestParty loaded! ALL chests are GOLDEN!")
