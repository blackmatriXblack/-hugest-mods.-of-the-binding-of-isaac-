-- ==========================================================================
--  Clicker Class - The Binding of Isaac: Repentance
--  Clicker shows which character it will change to before use
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("ClickerClass", 1)
local game = Game()

local CLICKER = CollectibleType.COLLECTIBLE_CLICKER
local characterNames = {
    "Isaac", "Magdalene", "Cain", "Judas", "???",
    "Eve", "Samson", "Azazel", "Lazarus", "Eden",
    "The Lost", "Lilith", "Keeper", "Apollyon",
    "The Forgotten", "Bethany", "Jacob & Esau"
}

function mod:onRender()
    local player = Isaac.GetPlayer(0)
    if not player or not player:HasCollectible(CLICKER) then return end

    -- Check if clicker is active item
    local hasClicker = false
    for slot = 0, 3 do
        if player:GetActiveItem(slot) == CLICKER then
            hasClicker = true
            break
        end
    end
    if not hasClicker then return end

    -- Use a seeded random to predict next character
    local rng = player:GetCollectibleRNG(CLICKER)
    local nextChar = (rng:Next() % #characterNames) + 1
    local predictedName = characterNames[nextChar]

    local screenPos = Isaac.WorldToScreen(player.Position)
    Isaac.RenderText("Next: " .. predictedName,
        screenPos.X + 40, screenPos.Y + 20,
        1, 1, 0.9, 0.6, 0.1)

    -- Also show current character
    local currentType = player:GetPlayerType()
    Isaac.RenderText("Current: " .. tostring(currentType),
        screenPos.X + 40, screenPos.Y + 35,
        1, 0.7, 0.7, 0.7, 0.7)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("ClickerClass loaded!")
