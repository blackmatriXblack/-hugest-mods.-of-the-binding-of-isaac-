-- =============================================================================
--  LuckyRockCoin - The Binding of Isaac: Repentance
--  Lucky Rock trinket gives 2 coins instead of 1 when destroying rocks
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("LuckyRockCoin", 1)
local TRINKET_LUCKY_ROCK = 15

function mod:onPlayerUpdate(player)
    if not player:HasTrinket(TRINKET_LUCKY_ROCK) then return end

    local data = player:GetData()
    local curCoins = player:GetNumCoins()
    local prevCoins = data.lrPrevCoins or curCoins

    if curCoins > prevCoins then
        -- Coin was acquired (likely from rock destruction)
        -- Grant an extra coin
        player:AddCoins(1)
    end

    data.lrPrevCoins = curCoins
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("LuckyRockCoin loaded!")
