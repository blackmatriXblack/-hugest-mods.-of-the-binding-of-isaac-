-- =============================================================================
--  TaintedCollectibleGlow — The Binding of Isaac: Repentance
--  Tainted-character-exclusive collectibles have a red glow visual.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedCollectibleGlow", 1)

local TAINTED_ITEMS = {
    [CollectibleType.COLLECTIBLE_BIRTHRIGHT] = true,
    [CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING] = true,
    [CollectibleType.COLLECTIBLE_FLIP] = true,
    [CollectibleType.COLLECTIBLE_SUMPTORIUM] = true,
    [CollectibleType.COLLECTIBLE_GENESIS] = true,
    [CollectibleType.COLLECTIBLE_DARK_ARTS] = true,
    [CollectibleType.COLLECTIBLE_ANIMA_SOLA] = true,
    [CollectibleType.COLLECTIBLE_CLAW_MACHINE] = true,
}

local RED_GLOW = Color(1.0, 0.1, 0.1, 0.8, 1.0, 0.8, 0.8)

function mod:OnEntitySpawn(entity)
    if entity.Type ~= EntityType.ENTITY_PICKUP then return end
    if entity.Variant ~= PickupVariant.PICKUP_COLLECTIBLE then return end

    local pickup = entity:ToPickup()
    if not pickup then return end

    local subType = pickup.SubType
    if TAINTED_ITEMS[subType] then
        entity:SetColor(RED_GLOW, 9999, 1, true, false)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.OnEntitySpawn)
Isaac.DebugString("TaintedCollectibleGlow loaded!")
