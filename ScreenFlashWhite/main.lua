-- ==========================================================================
--  ScreenFlashWhite - The Binding of Isaac: Repentance
--  Taking damage flashes the screen white briefly for impact!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("ScreenFlashWhite", 1)
local flashAlpha = 0
local FLASH_DECAY = 0.08

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, countdown)
    if entity:ToPlayer() then
        flashAlpha = math.min(1, amount * 0.5)
        Game():ScreenShake(amount * 2, 10)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if flashAlpha <= 0 then return end

    local w, h = Isaac.GetScreenWidth(), Isaac.GetScreenHeight()
    local r1 = flashAlpha * 0.8
    local g1 = flashAlpha * 0.3
    local b1 = flashAlpha * 0.2

    Isaac.RenderScaledText("",
        w/2, h/2, 0, 0, 0, 0, 0)

    Isaac.RenderText("",
        w/2, h/2, r1, g1, b1, flashAlpha * 0.5, 0)

    flashAlpha = flashAlpha - FLASH_DECAY
    if flashAlpha < 0 then flashAlpha = 0 end
end)

Isaac.DebugString("ScreenFlashWhite loaded! OUCH!")
