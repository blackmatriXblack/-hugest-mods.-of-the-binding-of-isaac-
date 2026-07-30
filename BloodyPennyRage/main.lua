-- =============================================================================
--  BloodyPennyRage - The Binding of Isaac: Repentance
--  Bloody Penny trinket gives +0.5 damage per coin picked up
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BloodyPennyRage", 1)
local TRINKET_BLOODY_PENNY = 9

function mod:onPlayerUpdate(player)
    local data = player:GetData()

    if not player:HasTrinket(TRINKET_BLOODY_PENNY) then
        if data.bpBonus and data.bpBonus > 0 then
            data.bpBonus = 0
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
        end
        return
    end

    local curCoins = player:GetNumCoins()
    local prevCoins = data.bpPrevCoins or curCoins

    if curCoins > prevCoins then
        data.bpBonus = (data.bpBonus or 0) + 0.5
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
        player:EvaluateItems()
    end

    data.bpPrevCoins = curCoins
end

function mod:onCacheUpdate(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_DAMAGE then
        local bonus = player:GetData().bpBonus or 0
        if bonus > 0 and player:HasTrinket(TRINKET_BLOODY_PENNY) then
            player.Damage = player.Damage + bonus
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCacheUpdate)
Isaac.DebugString("BloodyPennyRage loaded!")
