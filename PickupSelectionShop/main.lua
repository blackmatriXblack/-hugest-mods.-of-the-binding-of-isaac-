-- =============================================================================
--  PickupSelectionShop — The Binding of Isaac: Repentance
--  MC_POST_PICKUP_SELECTION: When browsing shop items, highlight ones you
--  can afford in green, unaffordable in red.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PickupSelectionShop", 1)

function mod:onPostPickupSelection(pickup, price, canAfford)
    if not pickup:Exists() then return nil end

    local player = Isaac.GetPlayer(0)
    if not player then return nil end

    local playerCoins = player:GetNumCoins()

    if canAfford or (price and playerCoins >= price) then
        pickup:SetColor(Color(0.4, 1.0, 0.4, 1.0, 0, 0, 0), 99999, 1)
    else
        pickup:SetColor(Color(1.0, 0.3, 0.3, 1.0, 0, 0, 0), 99999, 1)
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, mod.onPostPickupSelection)

Isaac.DebugString("PickupSelectionShop loaded!")
