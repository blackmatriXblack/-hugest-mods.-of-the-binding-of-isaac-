-- ==========================================================================
--  Soul of Apollyon Void - The Binding of Isaac: Repentance
--  Soul of Apollyon also voids the nearest 3 pickups
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SoulOfApollyonVoid", 1)
local game = Game()

local SOUL_APOLLYON = CollectibleType.COLLECTIBLE_SOUL_OF_APOLLYON

function mod:onUseItem(itemType, rng, player)
    if itemType ~= SOUL_APOLLYON then return end

    -- Find nearest 3 pickups and absorb them
    local pickups = {}
    local entities = Isaac.GetRoomEntities()
    for _, ent in ipairs(entities) do
        if ent.Type == EntityType.ENTITY_PICKUP then
            local pickup = ent:ToPickup()
            if pickup then
                local dist = (player.Position - pickup.Position):Length()
                table.insert(pickups, {dist = dist, pickup = pickup})
            end
        end
    end

    -- Sort by distance
    table.sort(pickups, function(a, b) return a.dist < b.dist end)

    -- Void nearest 3
    local voided = 0
    for _, p in ipairs(pickups) do
        if voided >= 3 then break end
        local pickup = p.pickup
        -- Convert to damage/stats based on pickup type
        if pickup.Variant == PickupVariant.PICKUP_HEART then
            player:AddHearts(2)
        elseif pickup.Variant == PickupVariant.PICKUP_COIN then
            player:AddCoins(1)
        elseif pickup.Variant == PickupVariant.PICKUP_KEY then
            player:AddKeys(1)
        elseif pickup.Variant == PickupVariant.PICKUP_BOMB then
            player:AddBombs(1)
        end
        pickup:Remove()
        voided = voided + 1
    end

    Isaac.DebugString("SoulOfApollyonVoid: voided " .. voided .. " pickups")
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem, SOUL_APOLLYON)
Isaac.DebugString("SoulOfApollyonVoid loaded!")
