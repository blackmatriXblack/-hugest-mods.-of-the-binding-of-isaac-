-- ==========================================================================
--  Glass Cannon Mode - The Binding of Isaac: Repentance
--  Player has 1 HP max but deals 10x damage — cannot gain HP
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("GlassCannonMode", 1)
local game = Game()
local DMG_MULT = 10

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
    -- Force HP to 1 heart container (2 half hearts)
    local maxHearts = player:GetMaxHearts()
    if maxHearts > 2 then
        player:AddMaxHearts(-maxHearts + 2, false)
    end
    player:AddHearts(2)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    -- Enforce 1 HP max
    local maxHearts = player:GetMaxHearts()
    if maxHearts > 2 then
        player:AddMaxHearts(-maxHearts + 2, false)
    end

    -- Prevent soul/black hearts from being added
    local soulHearts = player:GetSoulHearts()
    if soulHearts > 0 then
        player:AddSoulHearts(-soulHearts)
    end

    -- Apply damage multiplier
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)

    -- Glassy/transparent visual effect
    player:SetColor(Color(0.5, 0.8, 1, 0.6, 0, 0, 0), -1, 1, false, false)

    -- Spawn glass shard particles on movement
    if math.random() < 0.05 then
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE,
            0, player.Position, Vector(math.random(-1, 1), math.random(-1, 1)), nil)
    end
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage * DMG_MULT
    end
end)

-- Block HP up items/pickups
mod:AddCallback(ModCallbacks.MC_POST_ITEM_PICKUP, function(_, pickupPlayer, itemType)
    -- Check if item gives HP up (many items do)
    local hpUpItems = {
        CollectibleType.COLLECTIBLE_BREAKFAST,
        CollectibleType.COLLECTIBLE_DESSERT,
        CollectibleType.COLLECTIBLE_DINNER,
        CollectibleType.COLLECTIBLE_LUNCH,
        CollectibleType.COLLECTIBLE_ROTTEN_MEAT,
        CollectibleType.COLLECTIBLE_SUPPER,
        CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM,
        CollectibleType.COLLECTIBLE_MEAT,
    }
    for _, id in ipairs(hpUpItems) do
        if itemType == id then
            -- Replace with damage up item equivalent
            pickupPlayer:RemoveCollectible(itemType)
            pickupPlayer:AddCollectible(CollectibleType.COLLECTIBLE_GROWTH_HORMONES, 0, false)
        end
    end
end)

Isaac.DebugString("Glass Cannon Mode loaded!")
