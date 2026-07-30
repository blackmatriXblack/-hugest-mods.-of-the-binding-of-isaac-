-- ==========================================================================
--  Item Durability - The Binding of Isaac: Repentance
--  Items break after 3 floors of use and are removed
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("ItemDurability", 1)
local game = Game()
local itemAge = {}  -- {[itemId] = floorsHad}
local DURABILITY_MAX = 3
local currentFloor = 0

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    currentFloor = currentFloor + 1

    local player = game:GetPlayer(0)
    if not player then return end

    -- Age all items and remove broken ones
    local itemsToRemove = {}
    for itemId, floors in pairs(itemAge) do
        itemAge[itemId] = floors + 1
        if itemAge[itemId] >= DURABILITY_MAX then
            -- Item broke!
            player:RemoveCollectible(itemId)
            table.insert(itemsToRemove, itemId)
            
            -- Break effect
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02,
                0, player.Position, Vector.Zero, nil)
            Isaac.DebugString(string.format("Item %d has broken after %d floors!",
                itemId, DURABILITY_MAX))
        end
    end

    -- Clean up broken item records
    for _, id in ipairs(itemsToRemove) do
        itemAge[id] = nil
    end
end)

-- Track newly picked up items
mod:AddCallback(ModCallbacks.MC_POST_ITEM_PICKUP, function(_, pickupPlayer, itemType)
    if not itemAge[itemType] then
        itemAge[itemType] = 0
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local player = game:GetPlayer(0)
    if player then
        local y = 60
        for itemId, floors in pairs(itemAge) do
            local remaining = DURABILITY_MAX - floors
            if remaining <= 1 then
                local itemConfig = Isaac.GetItemConfig()
                local itemData = itemConfig:GetCollectible(itemId)
                local itemName = itemData and itemData.Name or "???"
                Isaac.RenderText(string.format("%s: %d floor(s) left",
                    itemName, remaining),
                    10, y, 0.5, 1, 0.8, 0.3)
                y = y + 12
                if y > 200 then break end
            end
        end
    end
end)

Isaac.DebugString("Item Durability loaded!")
