-- =============================================================================
--  BlessedPennyAngel - The Binding of Isaac: Repentance
--  Blessed Penny trinket grants an eternal heart every 10 coins picked up
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BlessedPennyAngel", 1)
local TRINKET_BLESSED_PENNY = 50

function mod:onPlayerUpdate(player)
    if not player:HasTrinket(TRINKET_BLESSED_PENNY) then return end

    local data = player:GetData()
    local curCoins = player:GetNumCoins()
    local prevCoins = data.blPrevCoins or curCoins

    if curCoins > prevCoins then
        data.blCounter = (data.blCounter or 0) + 1
        if data.blCounter >= 10 then
            data.blCounter = 0
            player:AddEternalHearts(1)
        end
    end

    data.blPrevCoins = curCoins
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("BlessedPennyAngel loaded!")
