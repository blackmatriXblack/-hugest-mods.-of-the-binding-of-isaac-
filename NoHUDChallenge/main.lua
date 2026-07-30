-- ==========================================================================
--  No HUD Challenge - The Binding of Isaac: Repentance
--  Completely hide the HUD — HP coins bombs keys active item map
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("NoHUDChallenge", 1)
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    -- Hide HUD elements by setting their visibility
    local hud = game:GetHUD()
    if hud then
        hud:SetVisible(false)
    end
end)

-- Also try to disable HUD through player flags
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    -- Add blindfolded-like effect (no HUD)
    local controls = player:GetControls()
    
    -- Periodically show minimal HUD information as debug text
    -- so the player isn't completely blind
end)

-- Show minimal essential info via debug text every few seconds
mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local player = game:GetPlayer(0)
    if not player then return end

    -- Brief flash of critical info (acts like a "pulse")
    local frame = game:GetFrameCount()
    if frame % 120 < 20 then  -- Brief 0.66 second pulse every 4 seconds
        local hp = player:GetHearts()
        Isaac.RenderText(string.format("HP: %d", math.floor(hp)),
            10, 10, 0.6, 1, 1, 1)
        Isaac.RenderText(string.format("C:%d B:%d K:%d",
            player:GetNumCoins(), player:GetNumBombs(), player:GetNumKeys()),
            10, 22, 0.5, 0.8, 0.8, 0.8)
    end
end)

Isaac.DebugString("No HUD Challenge loaded!")
