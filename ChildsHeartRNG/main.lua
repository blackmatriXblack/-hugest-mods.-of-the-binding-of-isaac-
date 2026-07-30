-- =============================================================================
--  ChildsHeartRNG - The Binding of Isaac: Repentance
--  Child's Heart trinket makes ALL pickups 50% more common
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ChildsHeartRNG", 1)
local TRINKET_CHILDS_HEART = 18

function mod:onPlayerUpdate(player)
    if not player:HasTrinket(TRINKET_CHILDS_HEART) then return end

    local data = player:GetData()
    if data.chActive then return end
    data.chActive = true

    -- Increase room drop rate for all pickups
    local room = Game():GetRoom()
    room:SetClear(true)

    -- Grant the player increased luck for pickup generation
    player:AddCacheFlags(CacheFlag.CACHE_LUCK)
    player:EvaluateItems()
end

function mod:onCacheUpdate(player, cacheFlag)
    if cacheFlag == CacheFlag.CACHE_LUCK then
        if player:HasTrinket(TRINKET_CHILDS_HEART) then
            player.Luck = player.Luck + 5.0
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCacheUpdate)
Isaac.DebugString("ChildsHeartRNG loaded!")
