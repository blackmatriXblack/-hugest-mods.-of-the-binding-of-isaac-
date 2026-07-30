-- =============================================================================
--  BookwormTransformation - The Binding of Isaac: Repentance
--  Bookworm transformation grants +2 luck and 15% chance per room to drop a random card
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BookwormTransformation", 1)

local bookItems = {
    CollectibleType.COLLECTIBLE_BIBLE,
    CollectibleType.COLLECTIBLE_BOOK_OF_BELIAL,
    CollectibleType.COLLECTIBLE_BOOK_OF_REVELATIONS,
    CollectibleType.COLLECTIBLE_BOOK_OF_SHADOWS,
    CollectibleType.COLLECTIBLE_BOOK_OF_SIN,
    CollectibleType.COLLECTIBLE_MONSTER_MANUAL,
    CollectibleType.COLLECTIBLE_TELEPATHY_FOR_DUMMIES,
    CollectibleType.COLLECTIBLE_THE_NECRONOMICON,
    CollectibleType.COLLECTIBLE_BOOK_OF_SECRETS,
    CollectibleType.COLLECTIBLE_SATANIC_BIBLE,
    CollectibleType.COLLECTIBLE_BOOK_OF_THE_DEAD,
    CollectibleType.COLLECTIBLE_ANARCHIST_COOKBOOK,
    CollectibleType.COLLECTIBLE_HOW_TO_JUMP,
}

local function isBookworm(player)
    local count = 0
    for _, id in ipairs(bookItems) do
        if player:HasCollectible(id) then count = count + 1 end
    end
    return count >= 3
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if cacheFlag & CacheFlag.CACHE_LUCK ~= CacheFlag.CACHE_LUCK then return end
    if isBookworm(player) then
        player.Luck = player.Luck + 2.0
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    for i = 0, game:GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(i)
        if isBookworm(player) then
            if math.random(100) <= 15 then
                local pos = game:GetRoom():FindFreePickupSpawnPosition(player.Position, 40, true)
                local cardType = math.random(Card.CARD_FOOL, Card.CARD_JUSTICE)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD,
                    cardType, pos, Vector(0, 0), player)
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if isBookworm(player) then
        player:AddCacheFlags(CacheFlag.CACHE_LUCK)
    end
end)

Isaac.DebugString("BookwormTransformation loaded!")
