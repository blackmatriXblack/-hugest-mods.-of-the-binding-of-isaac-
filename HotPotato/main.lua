-- ==========================================================================
--  Hot Potato - The Binding of Isaac: Repentance
--  Active item automatically uses itself every 10 seconds if charged
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("HotPotato", 1)
local game = Game()
local autoUseTimer = 0
local AUTO_USE_DELAY = 300 -- 10 seconds at 30fps

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    autoUseTimer = autoUseTimer + 1

    if autoUseTimer >= AUTO_USE_DELAY then
        autoUseTimer = 0
        local activeItem = player:GetActiveItem()

        if activeItem ~= CollectibleType.COLLECTIBLE_NULL then
            local itemCharge = player:GetActiveCharge()
            local itemConfig = Isaac.GetItemConfig()
            local itemData = itemConfig:GetCollectible(activeItem)

            if itemData and itemCharge >= 0 then
                -- Use the active item automatically
                player:UseActiveItem(UseFlag.USE_NOANIM, -1)

                -- Visual feedback
                local pos = player.Position
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02,
                    0, pos, Vector.Zero, nil)
                Isaac.DebugString("Hot Potato: Active item auto-used!")
            end
        end
    end

    -- Countdown warning near activation
    if autoUseTimer > AUTO_USE_DELAY - 60 then
        player:SetColor(Color(1, 0.6, 0.6, 1, 0, 0, 0), -1, 1, false, false)
    end
end)

-- Show countdown on screen
mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if autoUseTimer > AUTO_USE_DELAY - 90 then
        local secondsLeft = math.ceil((AUTO_USE_DELAY - autoUseTimer) / 30)
        Isaac.RenderText(string.format("Auto-use in %d...", secondsLeft),
            250, 20, 0.8, 1, 0.8, 0.2)
    end
end)

Isaac.DebugString("Hot Potato loaded!")
