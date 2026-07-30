-- =============================================================================
--  PostPurchaseDiscount - The Binding of Isaac: Repentance
--  Next shop purchase is 25% off after buying any item.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PostPurchaseDiscount", 1)
local discountActive = false

function mod:onPostPurchase(player, pickupFlag)
    discountActive = true
    Isaac.DebugString("Discount active! Next purchase 25% off.")
end

function mod:onPrePurchase(player, pickupFlag)
    if not discountActive then return end
    discountActive = false
    -- Reduce price by 25% by refunding coins
    local cost = pickupFlag.Price
    if cost > 0 then
        local refund = math.floor(cost * 0.25)
        if refund > 0 then
            player:AddCoins(refund)
            Isaac.DebugString("Discount applied: " .. refund .. " coins refunded.")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PURCHASE, mod.onPostPurchase)
mod:AddCallback(ModCallbacks.MC_PRE_PURCHASE, mod.onPrePurchase)
Isaac.DebugString("PostPurchaseDiscount loaded!")
