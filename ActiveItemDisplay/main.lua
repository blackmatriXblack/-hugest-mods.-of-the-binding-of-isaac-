-- Display active item ID and name on screen
local mod = RegisterMod("ActiveItemDisplay", 1)
local game = Game()

function mod:onPostRender()
    local player = Isaac.GetPlayer(0)
    if player then
        local activeId = player:GetActiveItem(0)
        if activeId and activeId > 0 then
            local itemConfig = Isaac.GetItemConfig()
            local itemName = "Unknown"
            if itemConfig then
                local collectible = itemConfig:GetCollectible(activeId)
                if collectible then
                    itemName = collectible.Name
                end
            end
            Isaac.RenderText("Active Item: " .. activeId .. " - " .. itemName, 60, 180, 1, 1, 1, 1)
        else
            Isaac.RenderText("Active Item: None", 60, 180, 1, 1, 1, 1)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("ActiveItemDisplay loaded! Shows active item ID and name on screen.")
