-- =============================================================================
--  DevilDealCheaper — The Binding of Isaac: Repentance
--  Devil deals cost soul hearts OR red hearts (player's choice — half of each).
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DevilDealCheaper", 1)

function mod:AlternateDealCost(player, pickupFlags, shopItemId, price)
    local playerEntity = player:ToPlayer()
    if not playerEntity then return nil end

    local redHearts = playerEntity:GetHearts()
    local soulHearts = playerEntity:GetSoulHearts()

    if pickupFlags & PickupPrice.PICKUP_PRICE_DEVIL > 0 then
        -- Check if price can be split: half red hearts, half soul hearts
        local halfPrice = price / 2

        if redHearts >= halfPrice and soulHearts >= halfPrice then
            -- Reduce red hearts only (soul hearts handled automatically or via return value)
            playerEntity:AddHearts(-halfPrice)
            return halfPrice  -- remaining half paid via soul hearts
        elseif soulHearts >= price then
            -- Pay entirely with soul hearts
            return price
        elseif redHearts >= price then
            -- Pay entirely with red hearts
            playerEntity:AddHearts(-price)
            return 0
        end
    end

    return nil  -- default behavior
end

mod:AddCallback(ModCallbacks.MC_PRE_PURCHASE, mod.AlternateDealCost)
Isaac.DebugString("DevilDealCheaper loaded!")
