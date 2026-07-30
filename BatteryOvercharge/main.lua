-- =============================================================================
--  BatteryOvercharge — The Binding of Isaac: Repentance
--  Battery pickups can overcharge — small batteries give 2 charges, big batteries give double charge.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BatteryOvercharge", 1)

local OVERCHARGE_CHANCE = 0.2  -- 20% chance

function mod:OverchargeBattery(pickup, variant, subtype)
    if variant ~= PickupVariant.PICKUP_BATTERY then return end

    if math.random() < OVERCHARGE_CHANCE then
        local player = Isaac.GetPlayer(0)
        if not player then return end

        -- Small battery = 1 charge normally, big = full charge
        if subtype == 0 then
            -- Small battery: add 2 charges instead of 1
            for i = 1, player:GetActiveItemsNum() - 1 do
                local activeItem = player:GetActiveItem(i)
                if activeItem ~= CollectibleType.COLLECTIBLE_NULL then
                    player:AddActiveCharge(activeItem, 2)
                end
            end
        elseif subtype == 1 then
            -- Big battery: double full charge
            for i = 0, player:GetActiveItemsNum() - 1 do
                local activeItem = player:GetActiveItem(i)
                if activeItem ~= CollectibleType.COLLECTIBLE_NULL then
                    local maxCharges = Isaac.GetItemConfig():GetCollectible(activeItem).MaxCharges
                    player:SetActiveCharge(activeItem, maxCharges)
                    player:AddActiveCharge(activeItem, maxCharges)  -- double it
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.OverchargeBattery)
Isaac.DebugString("BatteryOvercharge loaded!")
