-- =============================================================================
--  Total Chaos Randomizer - The Binding of Isaac: Repentance
--  Every 3 rooms, active item, trinket, and one passive get rerolled!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TotalChaosRandomizer", 1)
local roomCounter = 0

function mod:onNewRoom()
    roomCounter = roomCounter + 1
    if roomCounter % 3 ~= 0 then return end
    roomCounter = 0

    local player = Isaac.GetPlayer(0)
    if not player then return end

    -- Reroll active item
    local activeSlot = ActiveSlot.SLOT_PRIMARY
    local activeItem = player:GetActiveItem(activeSlot)
    if activeItem ~= CollectibleType.COLLECTIBLE_NULL then
        player:RemoveCollectible(activeItem, false, activeSlot)
        player:AddCollectible(Isaac.GetItemIdByName("Total Chaos Randomizer Active"), 0, false, activeSlot)
    end
    local newActive = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE, false)
    player:AddCollectible(newActive, 0, false, activeSlot)
    Isaac.DebugString("Active item rerolled!")

    -- Reroll trinket
    local trinket = player:GetTrinket(0)
    if trinket ~= TrinketType.TRINKET_NULL then
        player:TryRemoveTrinket(trinket)
    end
    local newTrinket = Game():GetItemPool():GetTrinket()
    player:AddTrinket(newTrinket)
    Isaac.DebugString("Trinket rerolled!")

    -- Reroll one random passive item
    local passives = {}
    for i = 0, player:GetCollectibleNum() - 1 do
        local item = player:GetCollectible(i)
        local itemConfig = Isaac.GetItemConfig():GetCollectible(item)
        if itemConfig and itemConfig.Type == ItemType.ITEM_PASSIVE then
            table.insert(passives, i)
        end
    end
    if #passives > 0 then
        local slot = passives[math.random(#passives)]
        local oldItem = player:GetCollectible(slot)
        player:RemoveCollectible(oldItem, false, slot)
        local newPassive = Game():GetItemPool():GetCollectible(ItemPoolType.POOL_TREASURE, false)
        player:AddCollectible(newPassive, 0, false, slot)
    end

    Isaac.DebugString("Total Chaos Randomizer: ALL rerolled! =)")
    Game():ShakeScreen(5)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("TotalChaosRandomizer loaded!")
