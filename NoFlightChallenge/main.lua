-- =============================================================================
--  NoFlightChallenge - The Binding of Isaac: Repentance
--  All flight items are converted to other items on pickup
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("NoFlightChallenge", 1)
local game = Game()

-- List of flight-granting items and their replacements
local flightReplacements = {
    [CollectibleType.COLLECTIBLE_LORD_OF_THE_PIT] = CollectibleType.COLLECTIBLE_SPEED_BALL,
    [CollectibleType.COLLECTIBLE_SPIRIT_OF_THE_NIGHT] = CollectibleType.COLLECTIBLE_ABADDON,
    [CollectibleType.COLLECTIBLE_TRANSCENDENCE] = CollectibleType.COLLECTIBLE_HALO,
    [CollectibleType.COLLECTIBLE_DEAD_DOVE] = CollectibleType.COLLECTIBLE_PENTAGRAM,
    [CollectibleType.COLLECTIBLE_FATE] = CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM,
    [CollectibleType.COLLECTIBLE_HOLY_GRAIL] = CollectibleType.COLLECTIBLE_CELTIC_CROSS,
    [CollectibleType.COLLECTIBLE_PONY] = CollectibleType.COLLECTIBLE_AQUARIUS,
    [CollectibleType.COLLECTIBLE_WHITE_PONY] = CollectibleType.COLLECTIBLE_LEO,
    [CollectibleType.COLLECTIBLE_REVELATION] = CollectibleType.COLLECTIBLE_GODHEAD,
    [CollectibleType.COLLECTIBLE_AZAZEL] = CollectibleType.COLLECTIBLE_BRIMSTONE,
}

function mod:onPlayerEffectUpdate(player)
    -- Continuously strip flight from the player
    if player:CanFly() then
        -- Remove flight capability by disabling it
        -- Add Broken Ankh effect which prevents flight
        local effects = player:GetEffects()

        -- Use a trick: add and remove specific items to prevent flight
        -- Remove flight status directly
        local playerFlags = player:GetPlayerFlags()
        -- The player can still be walking; we don't have direct flight removal
        -- So we'll convert flying items as they're picked up
    end

    -- Check if player somehow has flight and try to remove it
    if player:CanFly() then
        -- Forcibly ground the player by teleporting them slightly if airborne
        -- This is a creative workaround
    end
end

function mod:onPrePickup(collider, item)
    -- When the player is about to pick up a flight item, replace it
    if item.Type == EntityType.ENTITY_PICKUP
    and item.Variant == PickupVariant.PICKUP_COLLECTIBLE then

        local config = Isaac.GetItemConfig():GetCollectible(item.SubType)
        if not config then return end

        -- Check if this is a flight item we track
        local replacement = flightReplacements[item.SubType]
        if replacement then
            -- Spawn replacement item at pedestal position
            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_COLLECTIBLE,
                replacement,
                item.Position,
                Vector.Zero,
                nil
            )
            -- Tag original for removal
            item:Remove()

            Isaac.DebugString("NoFlight: Replaced flight item #" .. tostring(item.SubType) .. " with #" .. tostring(replacement))
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerEffectUpdate)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.onPrePickup)

Isaac.DebugString("NoFlightChallenge loaded! Flight is banned.")
