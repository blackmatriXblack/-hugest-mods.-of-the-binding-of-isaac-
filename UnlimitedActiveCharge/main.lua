-- =============================================================================
--  UNLIMITED ACTIVE CHARGE — The Binding of Isaac: Repentance
--  Your active item is always fully charged. Use it every room!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("UnlimitedActiveCharge", 1)

function mod:onUpdate()
    local player = Isaac.GetPlayer(0)
    if player == nil then return end
    -- Set active item to max charge for slot 0
    local maxCharge = player:GetActiveMaxCharge(0)
    if maxCharge > 0 then
        player:SetActiveCharge(0, maxCharge)
    end
    -- Also check slot 1 (for Schoolbag)
    if player:GetActiveMaxCharge(1) > 0 then
        player:SetActiveCharge(1, player:GetActiveMaxCharge(1))
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("Unlimited Active Charge loaded! Always fully charged.")
