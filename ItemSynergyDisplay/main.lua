-- =============================================================================
--  ItemSynergyDisplay - The Binding of Isaac: Repentance
--  Show a list of active item synergies and transformations on player
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ItemSynergyDisplay", 1)

-- Known transformation player types (from PlayerType enum)
local TRANSFORMATIONS = {
    [PlayerType.PLAYER_GUPPY] = {name = "Guppy", r = 0.3, g = 0.3, b = 1},
    [PlayerType.PLAYER_BEELZEBUB] = {name = "Lord of the Flies", r = 0.3, g = 0.6, b = 0.3},
    [PlayerType.PLAYER_BOB] = {name = "Bob", r = 0.3, g = 1, b = 0.3},
    [PlayerType.PLAYER_BOOKWORM] = {name = "Bookworm", r = 1, g = 0.8, b = 0.3},
    [PlayerType.PLAYER_SPUN] = {name = "Spun", r = 1, g = 0.3, b = 0.3},
    [PlayerType.PLAYER_ADULTHOOD] = {name = "Adult", r = 0.6, g = 0.4, b = 0.2},
    [PlayerType.PLAYER_STOMPY] = {name = "Stompy", r = 0.4, g = 0.4, b = 0.4},
    [PlayerType.PLAYER_FUN_GUY] = {name = "Fun Guy", r = 0.3, g = 1, b = 1},
    [PlayerType.PLAYER_CONJOINED] = {name = "Conjoined", r = 0.8, g = 0.3, b = 1},
    [PlayerType.PLAYER_SUPER_BUM] = {name = "Super Bum", r = 0.5, g = 0.2, b = 0.2},
    [PlayerType.PLAYER_YES_MOTHER] = {name = "Yes Mother?", r = 0.8, g = 0.8, b = 0.8},
    [PlayerType.PLAYER_LEVIATHAN] = {name = "Leviathan", r = 0.2, g = 0.2, b = 0.2},
    [PlayerType.PLAYER_SERAPHIM] = {name = "Seraphim", r = 1, g = 1, b = 1},
    [PlayerType.PLAYER_WHORE] = {name = "Whore of Babylon", r = 0.8, g = 0.2, b = 0.2},
}

function mod:onRender()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    local sw = Isaac.GetScreenWidth()
    local sh = Isaac.GetScreenHeight()
    local x = sw * 0.018
    local y = sh * 0.52

    Isaac.RenderScaledText("Synergies", x, y, 0.85, 0.85, 1, 0.6, 0.9, 1)

    local pt = player:GetPlayerType()
    local hasTransform = false

    if TRANSFORMATIONS[pt] then
        local t = TRANSFORMATIONS[pt]
        hasTransform = true
        y = y + 16
        Isaac.RenderScaledText("[T] " .. t.name, x, y, 0.75, 0.75, t.r, t.g, t.b, 1)
    end

    -- Check for known synergies via item combinations
    local itemNames = {}
    for i = 0, player:GetCollectibleCount() - 1 do
        local itemID = player:GetCollectibleID(i)
        if itemID and itemID > 0 then
            local cfg = Isaac.GetItemConfig():GetCollectible(itemID)
            if cfg then
                itemNames[#itemNames + 1] = cfg.Name
            end
        end
    end

    -- Brimstone + Spoon Bender synergy
    if player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE)
       and player:HasCollectible(CollectibleType.COLLECTIBLE_SPOON_BENDER) then
        y = y + 14
        Isaac.RenderScaledText("[S] Brimstone + Homing", x, y, 0.7, 0.7, 1, 0.4, 0.4, 1)
        hasTransform = true
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_TECHNOLOGY)
       and player:HasCollectible(CollectibleType.COLLECTIBLE_BRIMSTONE) then
        y = y + 14
        Isaac.RenderScaledText("[S] Tech + Brimstone", x, y, 0.7, 0.7, 1, 0.3, 0.3, 1)
        hasTransform = true
    end

    if player:HasCollectible(CollectibleType.COLLECTIBLE_DR_FETUS)
       and player:HasCollectible(CollectibleType.COLLECTIBLE_BOMB_BOMBS) then
        y = y + 14
        Isaac.RenderScaledText("[S] Dr. Fetus + Bombs", x, y, 0.7, 0.7, 0.7, 0.7, 0.3, 1)
        hasTransform = true
    end

    if not hasTransform then
        y = y + 16
        Isaac.RenderScaledText("None active", x, y, 0.6, 0.6, 0.4, 0.4, 0.4, 0.7)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("ItemSynergyDisplay loaded!")
