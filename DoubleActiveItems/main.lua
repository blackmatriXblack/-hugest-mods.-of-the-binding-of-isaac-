-- DoubleActiveItems: Keeps both active item slots fully charged (Schoolbag compatible)
local mod = RegisterMod("DoubleActiveItems", 1)

function mod:onPEffectUpdate(player)
    if player:GetActiveItem(0) ~= 0 then
        local maxCharge0 = player:GetActiveMaxCharge(0)
        player:SetActiveCharge(0, maxCharge0)
    end
    if player:GetActiveItem(1) ~= 0 then
        local maxCharge1 = player:GetActiveMaxCharge(1)
        player:SetActiveCharge(1, maxCharge1)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPEffectUpdate)
Isaac.DebugString("DoubleActiveItems loaded! Active items always fully charged.")
