-- =============================================================================
--  TaintedLilithWhip - The Binding of Isaac: Repentance
--  Tainted Lilith: Gello deals 2x damage at full charge.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedLilithWhip", 1)
local TAINTED_LILITH = 32
local GELLO = CollectibleType.COLLECTIBLE_GELLO -- id 728

function mod:onPEffectUpdate(player)
    if player:GetPlayerType() ~= TAINTED_LILITH then return end
    if not player:HasCollectible(GELLO) then return end

    local activeCharge = player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY)
    local maxCharge = 0
    for i = 0, 2 do
        local item = player:GetActiveItem(i)
        if item == GELLO then
            maxCharge = player:GetActiveMaxCharge(i)
            break
        end
    end

    if activeCharge >= maxCharge and maxCharge > 0 then
        player.Damage = player.Damage * 2
        Isaac.DebugString("TaintedLilithWhip: Full charge - 2x damage!")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
Isaac.DebugString("TaintedLilithWhip loaded!")
