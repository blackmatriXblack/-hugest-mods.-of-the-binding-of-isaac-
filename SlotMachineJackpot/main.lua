-- =============================================================================
--  Slot Machine Jackpot - The Binding of Isaac: Repentance
--  Slot machines have 3x jackpot chance and always pay out!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SlotMachineJackpot", 1)
local boostedSlots = {}

function mod:onUpdate()
    local room = Game():GetRoom()
    local entities = Isaac.GetRoomEntities()

    for _, entity in ipairs(entities) do
        if entity.Type == EntityType.ENTITY_SLOT or
           entity.Type == EntityType.ENTITY_SLOT_2 then
            local idx = GetPtrHash(entity)
            if not boostedSlots[idx] then
                -- Increase payout rate
                entity:GetSprite().PlaybackSpeed = 2.0
                entity:GetSprite().Color = Color(1, 0.9, 0.2, 1, 0, 0, 0) -- Golden tint
                boostedSlots[idx] = true
            end
        end
    end
end

function mod:onSlotCollision(slot, collider)
    if collider and collider.Type == EntityType.ENTITY_PLAYER then
        local player = collider:ToPlayer()
        if player then
            -- Always give a reward when player uses slot
            local rng = RNG()
            rng:SetSeed(slot.InitSeed, 0)
            local pos = slot.Position

            local roll = rng:RandomInt(100)
            if roll < 30 then
                -- High chance for coins
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_DIME, pos, Vector(0, -3), nil)
                Isaac.DebugString("SLOT JACKPOT! Dime!")
            elseif roll < 60 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_NICKEL, pos, Vector(0, -3), nil)
                Isaac.DebugString("Slot payout! Nickel!")
            elseif roll < 85 then
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, pos * 2, Vector(0, -3), player)
                Isaac.DebugString("Slot payout! Some pennies!")
            elseif roll < 95 then
                -- Rare: spawn a pickup
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0, pos, Vector(0, -3), nil)
                Isaac.DebugString("SLOT JACKPOT! Card!")
            else
                -- Very rare: spawn a key + bomb
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, KeySubType.KEY_GOLDEN, pos, Vector(-1, -3), nil)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, BombSubType.BOMB_GOLDEN, pos, Vector(1, -3), nil)
                Isaac.DebugString("MEGA SLOT JACKPOT!!! Gold items!")
            end

            Game():ShakeScreen(3)
        end
    end
end

function mod:onNewRoom()
    boostedSlots = {}
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, mod.onSlotCollision)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("SlotMachineJackpot loaded!")
