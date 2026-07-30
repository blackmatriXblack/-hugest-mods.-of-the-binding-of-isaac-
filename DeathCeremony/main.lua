-- =============================================================================
--  DeathCeremony — The Binding of Isaac: Repentance
--  On any death, spawn a random pickup at death location.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DeathCeremony", 1)

local deathLoot = {
    {PickupVariant.PICKUP_HEART, HeartSubType.HEART_FULL},
    {PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY},
    {PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL},
    {PickupVariant.PICKUP_KEY, KeySubType.KEY_NORMAL},
    {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_NORMAL},
    {PickupVariant.PICKUP_HEART, HeartSubType.HEART_HALF},
    {PickupVariant.PICKUP_COIN, CoinSubType.COIN_DIME},
    {PickupVariant.PICKUP_KEY, KeySubType.KEY_GOLDEN},
    {PickupVariant.PICKUP_BOMB, BombSubType.BOMB_DOUBLEPACK},
}

function mod:onDeath(entity)
    if entity and entity.Position then
        local pick = deathLoot[math.random(1, #deathLoot)]
        Isaac.Spawn(EntityType.ENTITY_PICKUP, pick[1], pick[2], entity.Position, Vector.Zero, nil)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_DEATH, mod.onDeath)
Isaac.DebugString("DeathCeremony loaded!")
