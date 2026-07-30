-- =============================================================================
--  PickupCollisionBonus — The Binding of Isaac: Repentance
--  10% chance pickup gives double value (coins 2x, hearts heal 2x).
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PickupCollisionBonus", 1)

function mod:onPostPickupCollision(pickup, collider, low)
    if pickup and collider and math.random() <= 0.1 then
        if pickup.Variant == PickupVariant.PICKUP_COIN then
            -- Double coin value: give extra coins
            local coinValue = 1
            if pickup.SubType == CoinSubType.COIN_NICKEL then coinValue = 5
            elseif pickup.SubType == CoinSubType.COIN_DIME then coinValue = 10
            elseif pickup.SubType == CoinSubType.COIN_LUCKYPENNY then coinValue = 1
            elseif pickup.SubType == CoinSubType.COIN_DOUBLEPACK then coinValue = 2
            elseif pickup.SubType == CoinSubType.COIN_STICKYNICKEL then coinValue = 5
            elseif pickup.SubType == CoinSubType.COIN_GOLDEN then coinValue = 1
            end
            collider:AddCoins(coinValue)
            -- Spawn extra coin visual effect
            for i = 1, coinValue do
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.COIN_PARTICLE, 0, pickup.Position, Vector.FromAngleDegrees(math.random(0, 360)) * 3, nil)
            end
            Isaac.DebugString("PickupCollisionBonus: Double coins! (+" .. tostring(coinValue) .. ")")
        elseif pickup.Variant == PickupVariant.PICKUP_HEART then
            -- Double heal: add more hearts
            local heartCount = 1
            if pickup.SubType == HeartSubType.HEART_DOUBLEPACK then heartCount = 2
            elseif pickup.SubType == HeartSubType.HEART_BLACK then heartCount = 1
            elseif pickup.SubType == HeartSubType.HEART_ETERNAL then heartCount = 1
            elseif pickup.SubType == HeartSubType.HEART_GOLDEN then heartCount = 1
            elseif pickup.SubType == HeartSubType.HEART_ROTTEN then heartCount = 1
            elseif pickup.SubType == HeartSubType.HEART_BONE then heartCount = 1
            elseif pickup.SubType == HeartSubType.HEART_HALF then heartCount = 1
            end
            for _ = 1, heartCount do
                collider:AddHearts(1)
            end
            Isaac.DebugString("PickupCollisionBonus: Double hearts! (+" .. tostring(heartCount) .. ")")
        elseif pickup.Variant == PickupVariant.PICKUP_KEY then
            collider:AddKeys(1)
            Isaac.DebugString("PickupCollisionBonus: Extra key!")
        elseif pickup.Variant == PickupVariant.PICKUP_BOMB then
            collider:AddBombs(1)
            Isaac.DebugString("PickupCollisionBonus: Extra bomb!")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_COLLISION, mod.onPostPickupCollision)
Isaac.DebugString("PickupCollisionBonus loaded!")
