-- =============================================================================
--  PreUseItemLog - The Binding of Isaac: Repentance
--  Floating item name above player before using active item.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PreUseItemLog", 1)
local itemNameText = ""
local itemNameTimer = 0
local itemPos = Vector.Zero

function mod:onPreUseItem(itemId, rng, player, useFlags, slot, varData)
    local itemConfig = Isaac.GetItemConfig():GetCollectible(itemId)
    if itemConfig then
        itemNameText = itemConfig.Name
    else
        itemNameText = "Unknown Item"
    end
    itemNameTimer = 90
    itemPos = player.Position
end

function mod:onPostRender()
    if itemNameTimer <= 0 then return end
    itemNameTimer = itemNameTimer - 1
    local screenPos = Isaac.WorldToScreen(itemPos)
    local alpha = math.min(1, itemNameTimer / 30)
    Isaac.RenderText(itemNameText, screenPos.X - 40, screenPos.Y - 50, 0.3, 0.5, 1, alpha)
end

mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, mod.onPreUseItem)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("PreUseItemLog loaded!")
