-- =============================================================================
--  ItemPoolShuffler — The Binding of Isaac: Repentance
--  Each floor, shuffle all item pools — items come from random pools.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ItemPoolShuffler", 1)

local POOL_TYPES = {
    ItemPoolType.POOL_TREASURE,
    ItemPoolType.POOL_SHOP,
    ItemPoolType.POOL_BOSS,
    ItemPoolType.POOL_DEVIL,
    ItemPoolType.POOL_ANGEL,
    ItemPoolType.POOL_SECRET,
    ItemPoolType.POOL_LIBRARY,
    ItemPoolType.POOL_CURSE,
    ItemPoolType.POOL_GOLDEN_CHEST,
    ItemPoolType.POOL_RED_CHEST,
    ItemPoolType.POOL_BEGGAR,
    ItemPoolType.POOL_DEMON_BEGGAR,
    ItemPoolType.POOL_KEY_MASTER,
    ItemPoolType.POOL_BATTERY_BUM,
    ItemPoolType.POOL_MOMS_CHEST,
    ItemPoolType.POOL_GREED_TREASURE,
    ItemPoolType.POOL_GREED_BOSS,
    ItemPoolType.POOL_GREED_SHOP,
    ItemPoolType.POOL_GREED_DEVIL,
    ItemPoolType.POOL_GREED_ANGEL,
    ItemPoolType.POOL_GREED_CURSE,
    ItemPoolType.POOL_GREED_SECRET,
    ItemPoolType.POOL_BOMB_BUM,
    ItemPoolType.POOL_ROTTEN_BEGGAR,
}

function mod:ShuffleAllPools()
    local itemPool = Game():GetItemPool()
    local allCollectibles = {}

    -- Collect all items from all pools
    for _, poolType in ipairs(POOL_TYPES) do
        local poolItems = itemPool:GetCollectibles(poolType)
        for i = 0, poolItems.Size - 1 do
            table.insert(allCollectibles, poolItems:Get(i))
        end
    end

    -- Remove all items from all pools
    for _, poolType in ipairs(POOL_TYPES) do
        local poolItems = itemPool:GetCollectibles(poolType)
        for i = poolItems.Size - 1, 0, -1 do
            itemPool:RemoveCollectible(poolType, poolItems:Get(i))
        end
    end

    -- Re-add all items to random pools
    for _, collectibleId in ipairs(allCollectibles) do
        local randomPool = POOL_TYPES[math.random(1, #POOL_TYPES)]
        itemPool:AddCollectible(randomPool, collectibleId, 1.0)
    end

    Isaac.DebugString("Item pools reshuffled for new floor!")
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.ShuffleAllPools)
Isaac.DebugString("ItemPoolShuffler loaded!")
