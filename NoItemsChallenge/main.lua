-- =============================================================================
--  NoItemsChallenge - The Binding of Isaac: Repentance
--  All item pedestals vanish and turn into coins instead
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("NoItemsChallenge", 1)
local game = Game()

local coinTypes = {
    CoinSubType.COIN_PENNY,
    CoinSubType.COIN_NICKEL,
    CoinSubType.COIN_DIME,
    CoinSubType.COIN_LUCKY_PENNY,
    CoinSubType.COIN_DOUBLE_PACK,
}

function mod:onPostEntitySpawn(entity)
    -- Check if the spawned entity is an item pedestal
    if entity.Type == EntityType.ENTITY_PICKUP
    and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then

        -- Get a random coin type with weighted chances
        local rng = RNG()
        rng:SetSeed(entity.InitSeed, 35)
        local roll = rng:RandomInt(100)
        local coinType

        if roll < 50 then
            coinType = CoinSubType.COIN_PENNY       -- 50% penny
        elseif roll < 75 then
            coinType = CoinSubType.COIN_NICKEL      -- 25% nickel
        elseif roll < 85 then
            coinType = CoinSubType.COIN_DIME        -- 10% dime
        elseif roll < 95 then
            coinType = CoinSubType.COIN_LUCKY_PENNY -- 10% lucky penny
        else
            coinType = CoinSubType.COIN_DOUBLE_PACK -- 5% double pack
        end

        -- Spawn coin at pedestal position and remove the pedestal
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COIN,
            coinType,
            entity.Position,
            Vector.Zero,
            nil
        )

        entity:Remove()
    end
end

function mod:onNewRoom()
    -- Scan for any remaining pedestals when entering a new room and remove them
    local room = game:GetRoom()
    if not room then return end

    for i = 0, room:GetGridSize() - 1 do
        local gridEntity = room:GetGridEntity(i)
        -- Not grid-related; scan entities instead
    end

    -- Entity scan for pedestals
    local entities = Isaac.GetRoomEntities()
    for _, ent in ipairs(entities) do
        if ent.Type == EntityType.ENTITY_PICKUP
        and ent.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            -- Replace with coin
            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                PickupVariant.PICKUP_COIN,
                CoinSubType.COIN_DIME,
                ent.Position,
                Vector.Zero,
                nil
            )
            ent:Remove()
        end
    end

    Isaac.DebugString("NoItemsChallenge: room cleaned of pedestals")
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onPostEntitySpawn)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)

Isaac.DebugString("NoItemsChallenge loaded!")
