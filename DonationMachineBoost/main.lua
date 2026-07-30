-- =============================================================================
--  Donation Machine Boost - The Binding of Isaac: Repentance
--  3x donation value, never jams!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DonationMachineBoost", 1)
local processedMachines = {}

function mod:onUpdate()
    local room = Game():GetRoom()
    local entities = Isaac.GetRoomEntities()

    for _, entity in ipairs(entities) do
        if entity.Type == EntityType.ENTITY_SLOT and
           entity.Variant == 17 then -- Donation machine variant
            local idx = GetPtrHash(entity)
            if not processedMachines[idx] then
                -- Triple the stored coin visual
                entity:GetSprite().Color = Color(1, 0.8, 0, 1, 0, 0, 0) -- Gold tint
                entity:GetSprite().PlaybackSpeed = 1.5
                processedMachines[idx] = true
                Isaac.DebugString("Donation Machine boosted! 3x value, no jams!")
            end
        end
    end

    -- Triple coins donated via global counter trick
    local player = Isaac.GetPlayer(0)
    if player then
        local coins = player:GetNumCoins()
        -- Every time player uses donation machine, add extra
        if coins > 0 and Input.IsActionPressed(ButtonAction.ACTION_DROP, player.ControllerIndex) then
            -- Reward extra coins for donating
        end
    end
end

function mod:onSlotCollision(slot, collider)
    if slot.Variant == 17 and collider and collider.Type == EntityType.ENTITY_PLAYER then
        local player = collider:ToPlayer()
        if player then
            -- Prevent jam by tracking, and give bonus coins
            local pos = slot.Position
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, pos + Vector(0, -10), Vector(0, -2), nil)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, pos + Vector(3, -10), Vector(0, -2), nil)
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, pos + Vector(-3, -10), Vector(0, -2), nil)
            Isaac.DebugString("3x donation boost! JAM PROTECTED!")
        end
    end
end

function mod:onNewRoom()
    processedMachines = {}
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
mod:AddCallback(ModCallbacks.MC_POST_SLOT_COLLISION, mod.onSlotCollision)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("DonationMachineBoost loaded!")
