-- FullHeartRefill: Always keeps player hearts at maximum
local mod = RegisterMod("FullHeartRefill", 1)

function mod:onPEffectUpdate(player)
    local currentHearts = player:GetHearts()
    local maxHearts = player:GetMaxHearts()
    if currentHearts < maxHearts then
        player:AddHearts(maxHearts - currentHearts)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
Isaac.DebugString("FullHeartRefill loaded! Hearts always max.")
