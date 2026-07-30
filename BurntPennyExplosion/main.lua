-- =============================================================================
--  BurntPennyExplosion - The Binding of Isaac: Repentance
--  Burnt Penny trinket causes small explosion on coin pickup
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BurntPennyExplosion", 1)
local TRINKET_BURNT_PENNY = 6

function mod:onPlayerUpdate(player)
    if not player:HasTrinket(TRINKET_BURNT_PENNY) then return end

    local data = player:GetData()
    local curCoins = player:GetNumCoins()
    local prevCoins = data.btPrevCoins or curCoins

    if curCoins > prevCoins then
        Isaac.Explode(player.Position, player, 20)
    end

    data.btPrevCoins = curCoins
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("BurntPennyExplosion loaded!")
