-- =============================================================================
--  FlatPennySpeed - The Binding of Isaac: Repentance
--  Flat Penny trinket gives speed boost on coin pickup (stacks 3 times)
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FlatPennySpeed", 1)
local TRINKET_FLAT_PENNY = 7

function mod:onPlayerUpdate(player)
    local data = player:GetData()

    if not player:HasTrinket(TRINKET_FLAT_PENNY) then
        if data.fpStacks and data.fpStacks > 0 then
            data.fpStacks = 0
            player:AddCacheFlags(CacheFlag.CACHE_SPEED)
            player:EvaluateItems()
        end
        return
    end

    local curCoins = player:GetNumCoins()
    local prevCoins = data.fpPrevCoins or curCoins

    if curCoins > prevCoins then
        data.fpStacks = math.min((data.fpStacks or 0) + 1, 3)
        player:AddCacheFlags(CacheFlag.CACHE_SPEED)
        player:EvaluateItems()
    end

    data.fpPrevCoins = curCoins
end

function mod:onCacheUpdate(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_SPEED then
        local stacks = player:GetData().fpStacks or 0
        if stacks > 0 and player:HasTrinket(TRINKET_FLAT_PENNY) then
            player.MoveSpeed = player.MoveSpeed + (stacks * 0.15)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCacheUpdate)
Isaac.DebugString("FlatPennySpeed loaded!")
