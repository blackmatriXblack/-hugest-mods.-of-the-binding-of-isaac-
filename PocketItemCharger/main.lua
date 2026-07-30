-- =============================================================================
--  PocketItemCharger — The Binding of Isaac: Repentance
--  Pocket active items slowly charge over time (1 charge per 30 seconds).
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PocketItemCharger", 1)
local CHARGE_INTERVAL = 900
local frameCounter = 0

local POCKET_SLOTS = {
    ActiveSlot.SLOT_POCKET,
    ActiveSlot.SLOT_POCKET2,
}

function mod:OnPlayerUpdate(player)
    frameCounter = frameCounter + 1
    if frameCounter < CHARGE_INTERVAL then return end
    frameCounter = 0

    for _, slot in ipairs(POCKET_SLOTS) do
        local item = player:GetActiveItem(slot)
        if item > 0 then
            local maxCharges = player:GetActiveMaxCharge(slot)
            local currentCharge = player:GetActiveCharge(slot)
            if currentCharge < maxCharges then
                player:SetActiveCharge(currentCharge + 1, slot)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.OnPlayerUpdate)
Isaac.DebugString("PocketItemCharger loaded!")
