-- ==========================================================================
--  ActiveItemCooldownBar - The Binding of Isaac: Repentance
--  Active item shows a cooldown timer bar when used!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("ActiveItemCooldownBar", 1)
local cooldownData = {}
local BAR_WIDTH = 120
local BAR_HEIGHT = 8

mod:AddCallback(ModCallbacks.MC_POST_USE_ITEM, function(_, itemId, rng)
    local player = Isaac.GetPlayer(0)
    if not player then return nil end

    local itemConfig = Isaac.GetItemConfig():GetCollectible(itemId)
    if itemConfig and itemConfig.MaxCharges > 0 then
        cooldownData = {
            active = true,
            maxCharges = itemConfig.MaxCharges,
            charges = 0,
            timer = 0,
            itemName = itemConfig.Name
        }
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    if not cooldownData.active then return end

    cooldownData.charges = player:GetActiveCharge(ActiveSlot.SLOT_PRIMARY)
    if cooldownData.charges >= cooldownData.maxCharges or cooldownData.charges == 0 then
        cooldownData.timer = cooldownData.timer + 1
        if cooldownData.timer > 30 then
            cooldownData = {}
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if not cooldownData.active or not cooldownData.itemName then return end

    local w, h = Isaac.GetScreenWidth(), Isaac.GetScreenHeight()
    local barX = w / 2 - BAR_WIDTH / 2
    local barY = h - 50
    local progress = cooldownData.charges / cooldownData.maxCharges

    local r, g, b = 0.3, 0.3, 0.3
    local fillR, fillG, fillB = 0.3, 0.7, 0.9

    Isaac.RenderText(cooldownData.itemName, barX, barY - 18, 1, 1, 1, 0.8, 1)

    for x = 0, BAR_WIDTH - 1, 2 do
        if x / BAR_WIDTH < progress then
            Isaac.RenderText("|", barX + x, barY, fillR, fillG, fillB, 0.9, 0.5)
        else
            Isaac.RenderText("|", barX + x, barY, r, g, b, 0.4, 0.5)
        end
    end
end)

Isaac.DebugString("ActiveItemCooldownBar loaded! Track your charges!")
