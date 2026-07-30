-- ==========================================================================
--  MinimapZoom - The Binding of Isaac: Repentance
--  Hold a key to zoom the minimap to 2x size temporarily!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("MinimapZoom", 1)
local isZoomed = false

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    if Input.IsActionPressed(ButtonAction.ACTION_MAP, player.ControllerIndex) then
        if not isZoomed then
            isZoomed = true
            SFXManager():Play(SoundEffect.SOUND_BLOODBANK, 0.3, 0, false, 1.5)
        end

        local minimap = Game():GetHUD()
        if minimap then
            minimap.MinimapScale = 2.0
            local w, h = Isaac.GetScreenWidth(), Isaac.GetScreenHeight()
            Isaac.RenderText("[ZOOMED]", w / 2 - 30, h - 30, 0.3, 0.8, 1, 0.8, 1)
        end
    else
        if isZoomed then
            isZoomed = false
            local minimap = Game():GetHUD()
            if minimap then
                minimap.MinimapScale = 1.0
            end
        end
    end
end)

Isaac.DebugString("MinimapZoom loaded! Hold MAP to zoom!")
