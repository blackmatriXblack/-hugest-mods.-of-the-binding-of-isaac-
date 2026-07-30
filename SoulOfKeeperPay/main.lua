-- ==========================================================================
--  Soul of Keeper Pay - The Binding of Isaac: Repentance
--  Soul of Keeper also drops 5 random coins
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SoulOfKeeperPay", 1)
local game = Game()

local SOUL_KEEPER = CollectibleType.COLLECTIBLE_SOUL_OF_KEEPER

function mod:onUseItem(itemType, rng, player)
    if itemType ~= SOUL_KEEPER then return end

    -- Drop 5 random coins around the player
    local coinTypes = {
        CoinSubType.COIN_PENNY,
        CoinSubType.COIN_NICKEL,
        CoinSubType.COIN_DIME,
        CoinSubType.COIN_LUCKYPENNY,
    }

    local pos = player.Position
    for i = 1, 5 do
        local coinType = coinTypes[(rng:Next() % #coinTypes) + 1]
        local offset = Vector(
            (rng:RandomFloat() - 0.5) * 60,
            (rng:RandomFloat() - 0.5) * 60
        )
        Isaac.Spawn(EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COIN, coinType,
            pos + offset,
            Vector(rng:RandomFloat() - 0.5, -2) * 3,
            player)
    end

    Isaac.DebugString("SoulOfKeeperPay: dropped 5 coins")
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem, SOUL_KEEPER)
Isaac.DebugString("SoulOfKeeperPay loaded!")
