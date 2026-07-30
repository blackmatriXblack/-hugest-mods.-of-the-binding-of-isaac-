-- =============================================================================
--  PostSacrificeReward — The Binding of Isaac: Repentance
--  MC_POST_SACRIFICE: Each sacrifice spawns a random coin/heart/bomb
--  in addition to normal rewards.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PostSacrificeReward", 1)

local REWARD_PICKUPS = {
    {type = PickupVariant.PICKUP_COIN, sub = CoinSubType.COIN_PENNY},
    {type = PickupVariant.PICKUP_COIN, sub = CoinSubType.COIN_NICKEL},
    {type = PickupVariant.PICKUP_HEART, sub = HeartSubType.HEART_FULL},
    {type = PickupVariant.PICKUP_HEART, sub = HeartSubType.HEART_HALF},
    {type = PickupVariant.PICKUP_BOMB, sub = BombSubType.BOMB_NORMAL},
    {type = PickupVariant.PICKUP_BOMB, sub = BombSubType.BOMB_DOUBLEPACK},
}

function mod:onPostSacrifice(player, numSacrifices)
    if not player:Exists() then return end

    local reward = REWARD_PICKUPS[math.random(1, #REWARD_PICKUPS)]
    local spawnPos = Game():GetRoom():FindFreePickupSpawnPosition(player.Position, 30, true)

    Isaac.Spawn(
        EntityType.ENTITY_PICKUP,
        reward.type,
        reward.sub,
        spawnPos,
        Vector.Zero,
        nil
    )
end
mod:AddCallback(ModCallbacks.MC_POST_SACRIFICE, mod.onPostSacrifice)

Isaac.DebugString("PostSacrificeReward loaded!")
