-- =============================================================================
--  CounterfeitPennyDouble - The Binding of Isaac: Repentance
--  Counterfeit Penny trinket has 75% chance to double coins instead of 50%
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CounterfeitPennyDouble", 1)
local TRINKET_COUNTERFEIT_PENNY = 8

function mod:onPlayerUpdate(player)
    if not player:HasTrinket(TRINKET_COUNTERFEIT_PENNY) then return end

    local data = player:GetData()
    local curCoins = player:GetNumCoins()
    local prevCoins = data.cpPrevCoins or curCoins

    if curCoins > prevCoins and math.random() < 0.5 then
        player:AddCoins(1)
        curCoins = player:GetNumCoins()
    end

    data.cpPrevCoins = curCoins
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("CounterfeitPennyDouble loaded!")
