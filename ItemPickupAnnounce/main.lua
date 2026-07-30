-- =============================================================================
--  ItemPickupAnnounce — The Binding of Isaac: Repentance
--  MC_POST_ITEM_PICKUP: When picking up items, display item name,
--  description, and quality as large HUD text for 3 seconds.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ItemPickupAnnounce", 1)

local EIT = EID and EID.ItemText or nil
local ANNOUNCE_DURATION = 90 -- 3 seconds at 30fps
local ANNOUNCE_DATA = {}     -- {playerIdx = {text, endFrame}}

function mod:onPostItemPickup(player, itemType, itemID)
    if not player:Exists() then return end

    local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
    if not itemConfig then return end

    local itemName = itemConfig.Name or "Unknown Item"
    local quality = itemConfig.Quality or 0
    local desc = itemConfig.Description or ""

    local announceText = string.format(
        "PICKED UP: %s (Q%d)",
        itemName, quality
    )

    local idx = GetPtrHash(player)
    ANNOUNCE_DATA[idx] = {
        text = announceText,
        endFrame = Isaac.GetFrameCount() + ANNOUNCE_DURATION,
    }
end
mod:AddCallback(ModCallbacks.MC_POST_ITEM_PICKUP, mod.onPostItemPickup)

function mod:onPostRender()
    for idx, data in pairs(ANNOUNCE_DATA) do
        if Isaac.GetFrameCount() < data.endFrame then
            local ratio = 1.0 - ((data.endFrame - Isaac.GetFrameCount()) / ANNOUNCE_DURATION)
            local alpha = 1.0
            if ratio < 0.1 then
                alpha = ratio / 0.1
            elseif ratio > 0.7 then
                alpha = (1.0 - ratio) / 0.3
            end

            Isaac.RenderText(
                data.text,
                80, 120,
                1.0, 0.8, 0.2,
                1.0, -- r, g, b, a
                math.floor(alpha * 255)
            )
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)

Isaac.DebugString("ItemPickupAnnounce loaded!")
