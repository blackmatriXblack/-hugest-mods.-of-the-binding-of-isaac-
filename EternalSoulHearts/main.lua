-- EternalSoulHearts: Always maintains 12 soul hearts and 6 black hearts
local mod = RegisterMod("EternalSoulHearts", 1)

function mod:onPEffectUpdate(player)
    local soulHearts = player:GetSoulHearts()
    local blackHearts = player:GetBlackHearts()
    if soulHearts < 24 then
        player:AddSoulHearts(24 - soulHearts)
    end
    if blackHearts < 12 then
        player:AddBlackHearts(12 - blackHearts)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
Isaac.DebugString("EternalSoulHearts loaded! 12 soul + 6 black hearts always.")
