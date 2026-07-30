-- =============================================================================
--  NewLevelBlessing — The Binding of Isaac: Repentance
--  On each new floor, spawn 3 random pickups in starting room.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("NewLevelBlessing", 1)

local pickupTypes = {
    {PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL},
    {PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY},
    {PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL},
    {PickupVariant.PICKUP_COIN, CoinSubType.COIN_DIME},
    {PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL},
    {PickupVariant.PICKUP_KEY, KeySubType.KEY_GOLDEN},
    {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL},
    {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_DOUBLEPACK},
    {PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF},
    {PickupVariant.PICKUP_HEART, HeartSubType.HEART_DOUBLEPACK},
}

function mod:onNewLevel()
    local level = Game():GetLevel()
    local startRoom = level:GetStartingRoom()
    if not startRoom then return end
    local pos = startRoom:GetCenterPos()
    for i = 1, 3 do
        local pick = pickupTypes[math.random(1, #pickupTypes)]
        local offset = Vector(math.random(-50, 50), math.random(-50, 50))
        Isaac.Spawn(EntityType.ENTITY_PICKUP, pick[1], pick[2], pos + offset, Vector.Zero, nil)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
Isaac.DebugString("NewLevelBlessing loaded!")
