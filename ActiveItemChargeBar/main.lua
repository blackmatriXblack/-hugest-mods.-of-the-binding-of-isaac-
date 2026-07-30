-- =============================================================================
--  ActiveItemChargeBar - The Binding of Isaac: Repentance
--  A bigger more visible charge bar for active items on screen
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ActiveItemChargeBar", 1)

function mod:onRender()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    local activeSlot = ActiveSlot.SLOT_PRIMARY
    local activeItem = player:GetActiveItem(activeSlot)
    if activeItem <= 0 then return end

    local charge = player:GetActiveCharge(activeSlot)
    local batteryCharge = player:GetBatteryCharge(activeSlot)
    local totalCharge = charge + batteryCharge

    local itemCfg = Isaac.GetItemConfig():GetCollectible(activeItem)
    if not itemCfg then return end

    local maxCharges = itemCfg.MaxCharges -- Actually need to check for battery items
    -- Get max charges (items with battery upgrades may have more)
    -- For simplicity, use typical max charges; the game's HUD already shows exact values
    if maxCharges <= 0 then maxCharges = 6 end

    local itemName = itemCfg.Name or "Active Item"
    local ratio = math.min(totalCharge / maxCharges, 1.0)

    local sw = Isaac.GetScreenWidth()
    local sh = Isaac.GetScreenHeight()
    local barX = sw * 0.25
    local barY = sh * 0.065
    local barW = sw * 0.5
    local barH = 18

    -- Background bar
    Isaac.RenderScaledText("■", barX, barY, barW * 0.06, 1.8, 0.15, 0.15, 0.15, 0.6)
    for i = 0, math.floor(barW / 8) - 1 do
        Isaac.RenderScaledText("■", barX + i * 8, barY, 0.12, 1.8, 0.15, 0.15, 0.15, 0.6)
    end

    -- Simplified bar using text
    local barLen = 40
    local filled = math.floor(ratio * barLen)
    local barStr = string.rep("█", filled) .. string.rep("░", barLen - filled)

    -- Color based on charge level
    local br, bg, bb = 0.2, 1, 0.4
    if ratio >= 1.0 then br, bg, bb = 1, 1, 0.2 end

    Isaac.RenderScaledText(barStr, barX, barY, 0.7, 0.7, br, bg, bb, 0.9)

    -- Item name and charge text
    Isaac.RenderScaledText(
        string.format("%s [%d/%d]", itemName, totalCharge, maxCharges),
        barX, barY + 16, 0.65, 0.65, 1, 1, 1, 1
    )

    -- Fully charged indicator
    if totalCharge >= maxCharges then
        local flash = math.sin(Game():GetFrameCount() * 0.1) * 0.5 + 0.5
        Isaac.RenderScaledText("READY!", barX + sw * 0.25, barY - 2, 1.0, 1.0, 1, 1, 0.2, 0.5 + flash * 0.5)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("ActiveItemChargeBar loaded!")
