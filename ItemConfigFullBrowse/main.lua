-- =============================================================================
--  ItemConfigFullBrowse — The Binding of Isaac: Repentance
--  On pressing Keyboard.Z, cycle through all items showing name/ID/quality.
--  Version: 1.0   | Official API only
-- =============================================================================

local mod = RegisterMod("ItemConfigFullBrowse", 1)
mod.currentItemId = 1
mod.showBrowser = false

function mod:onPostRender()
    -- Toggle browser with Z key
    if Input.IsButtonTriggered(Keyboard.KEY_Z, 0) then
        mod.showBrowser = not mod.showBrowser
    end

    if not mod.showBrowser then return end

    -- Navigate with arrow keys
    if Input.IsButtonTriggered(Keyboard.KEY_RIGHT, 0) then
        mod.currentItemId = mod.currentItemId + 1
    end
    if Input.IsButtonTriggered(Keyboard.KEY_LEFT, 0) then
        mod.currentItemId = math.max(1, mod.currentItemId - 1)
    end

    local itemConfig = Isaac.GetItemConfig()
    local item = itemConfig:GetCollectible(mod.currentItemId)
    if not item then
        mod.currentItemId = 1
        return
    end

    local lines = {
        "Item Browser (Z=toggle, arrows=navigate)",
        "ID: " .. tostring(mod.currentItemId),
        "Name: " .. (item.Name or "Unknown"),
        "Quality: " .. tostring(item.Quality),
        "Description: " .. (item.Description or "N/A"),
    }

    for idx, line in ipairs(lines) do
        Isaac.RenderText(line, 200, 10 + (idx - 1) * 14, 0.8, 0.8, 1, 1, 1)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("ItemConfigFullBrowse loaded!")
