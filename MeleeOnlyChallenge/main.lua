-- ==========================================================================
--  Melee Only Challenge - The Binding of Isaac: Repentance
--  All tear items converted to orbital/familiar items — player fires zero tears
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("MeleeOnlyChallenge", 1)
local game = Game()
local meleeReplacements = {
    -- Replace common tear items with melee/orbital equivalents
    [CollectibleType.COLLECTIBLE_SAD_ONION] = CollectibleType.COLLECTIBLE_SACRIFICIAL_DAGGER,
    [CollectibleType.COLLECTIBLE_INNER_EYE] = CollectibleType.COLLECTIBLE_BIG_FAN,
    [CollectibleType.COLLECTIBLE_SPOON_BENDER] = CollectibleType.COLLECTIBLE_ATHAME,
    [CollectibleType.COLLECTIBLE_CRICKETS_HEAD] = CollectibleType.COLLECTIBLE_MEAT_CLEAVER,
    [CollectibleType.COLLECTIBLE_MY_REFLECTION] = CollectibleType.COLLECTIBLE_GUARDIAN_ANGEL,
    [CollectibleType.COLLECTIBLE_NUMBER_ONE] = CollectibleType.COLLECTIBLE_FOREVER_ALONE,
    [CollectibleType.COLLECTIBLE_GROWTH_HORMONES] = CollectibleType.COLLECTIBLE_DISTANT_ADMIRATION,
    [CollectibleType.COLLECTIBLE_STEVEN] = CollectibleType.COLLECTIBLE_GEMINI,
}

-- Cancel all tear firing and replace picked up items
mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    tear:Remove()
end)

-- Replace tear-based items with melee alternatives on pickup
mod:AddCallback(ModCallbacks.MC_POST_ITEM_PICKUP, function(_, pickupPlayer, itemType)
    local replacement = meleeReplacements[itemType]
    if replacement then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
            replacement, pickupPlayer.Position, Vector.Zero, nil)
        pickupPlayer:RemoveCollectible(itemType)
    end
end)

-- Ensure orbitals get range/damage buffs to compensate
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
end)

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage * 2.5
    end
end)

Isaac.DebugString("Melee Only Challenge loaded!")
