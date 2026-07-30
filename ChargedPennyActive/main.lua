-- =============================================================================
--  ChargedPennyActive - The Binding of Isaac: Repentance
--  Charged Penny trinket gives 2 charges to active item instead of 1
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ChargedPennyActive", 1)
local TRINKET_CHARGED_PENNY = 51

function mod:onPlayerUpdate(player)
    if not player:HasTrinket(TRINKET_CHARGED_PENNY) then return end

    local data = player:GetData()
    local curCoins = player:GetNumCoins()
    local prevCoins = data.cgPrevCoins or curCoins

    if curCoins > prevCoins then
        local activeSlot = ActiveSlot.SLOT_PRIMARY
        local curCharge = player:GetActiveCharge(activeSlot)
        local activeItem = player:GetActiveItem(activeSlot)
        if activeItem ~= CollectibleType.COLLECTIBLE_NULL then
            player:SetActiveCharge(activeSlot, curCharge + 1)
        end
    end

    data.cgPrevCoins = curCoins
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("ChargedPennyActive loaded!")
