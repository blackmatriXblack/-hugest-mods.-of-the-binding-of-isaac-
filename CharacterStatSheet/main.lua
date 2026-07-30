-- =============================================================================
--  CharacterStatSheet — The Binding of Isaac: Repentance
--  Press Tab to show detailed character stats, items held, transformations.
--  Version: 1.0   | Official API only
-- =============================================================================

local mod = RegisterMod("CharacterStatSheet", 1)
local game = Game()
mod.showSheet = false

function mod:onPostRender()
    if Input.IsButtonTriggered(Keyboard.KEY_TAB, 0) then
        mod.showSheet = not mod.showSheet
    end
    if not mod.showSheet then return end

    local player = Isaac.GetPlayer(0)
    if not player then return end

    -- Stats
    local lines = {
        "=== Character Stats ===",
        "Damage: " .. string.format("%.2f", player.Damage),
        "Tears: " .. tostring(player.TearRate),
        "Shot Speed: " .. string.format("%.2f", player.ShotSpeed),
        "Range: " .. string.format("%.2f", player.TearRange),
        "Speed: " .. string.format("%.2f", player.MoveSpeed),
        "Luck: " .. string.format("%.2f", player.Luck),
        "",
        "=== Items Held ===",
    }

    -- Items
    for i = 0, 19 do
        local itemId = player:GetCollectible(i)
        if itemId and itemId ~= CollectibleType.COLLECTIBLE_NULL then
            local itemConfig = Isaac.GetItemConfig():GetCollectible(itemId)
            if itemConfig then
                table.insert(lines, "  " .. (itemConfig.Name or "Unknown") .. " (ID:" .. tostring(itemId) .. ")")
            end
        end
    end

    -- Transformations
    table.insert(lines, "")
    table.insert(lines, "=== Transformations ===")
    local transformNames = {
        "Guppy", "Fun Guy", "Beelzebub", "Bob", "Conjoined",
        "Spun", "Yes Mother?", "Leviathan", "Seraphim", "Oh Crap",
        "Bob", "Spider Baby", "Adult", "Stompy", "Super Bum"
    }
    local anyTransform = false
    for idx, tname in ipairs(transformNames) do
        local flag = 2 ^ (idx - 1)
        if player:HasPlayerForm(flag) then
            table.insert(lines, "  " .. tname)
            anyTransform = true
        end
    end
    if not anyTransform then
        table.insert(lines, "  None")
    end

    for lidx, line in ipairs(lines) do
        Isaac.RenderText(line, 350, 10 + (lidx - 1) * 12, 0.7, 0.7, 1, 1, 1)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("CharacterStatSheet loaded!")
