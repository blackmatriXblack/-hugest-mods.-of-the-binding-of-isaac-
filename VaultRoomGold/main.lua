-- =============================================================================
--  VaultRoomGold - The Binding of Isaac: Repentance
--  Vault rooms contain double the normal amount of coin pickups
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("VaultRoomGold", 1)

local function IsVaultRoom()
    local room = Game():GetRoom()
    local roomType = room:GetType()
    return roomType == RoomType.ROOM_VAULT
end

local function SpawnDoubleCoins()
    if not IsVaultRoom() then return end

    local room = Game():GetRoom()
    local center = room:GetCenterPos()

    -- Count existing coins in the room
    local existingCoins = 0
    local entities = Isaac.GetRoomEntities()
    for i = 0, entities.Size - 1 do
        local e = entities:Get(i)
        if e and e:Exists()
           and e.Type == EntityType.ENTITY_PICKUP
           and e.Variant == PickupVariant.PICKUP_COIN then
            existingCoins = existingCoins + 1
        end
    end

    -- If fewer than expected, spawn extra coins (double the standard amount)
    -- Standard vault: ~5-10 coins. We double: 10-20 total
    local targetCoins = math.max(existingCoins * 2, 10)
    local toSpawn = targetCoins - existingCoins

    if toSpawn <= 0 then return end

    local rng = RNG()
    rng:SetSeed(room:GetAwardSeed(), 2)

    for i = 1, toSpawn do
        local pos = Vector(
            center.X + rng:RandomInt(200) - 100,
            center.Y + rng:RandomInt(140) - 70
        )

        -- Variety of coin types: mostly pennies, some nickels, occasional dimes
        local coinType = CoinSubType.COIN_PENNY
        local roll = rng:RandomInt(100)
        if roll < 10 then
            coinType = CoinSubType.COIN_DIME
        elseif roll < 30 then
            coinType = CoinSubType.COIN_NICKEL
        elseif roll < 50 then
            coinType = CoinSubType.COIN_DOUBLEPACK
        end

        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COIN,
            coinType,
            pos,
            Vector(rng:RandomInt(5) - 2, rng:RandomInt(3) - 4),
            nil
        )
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, SpawnDoubleCoins)
Isaac.DebugString("VaultRoomGold loaded!")
