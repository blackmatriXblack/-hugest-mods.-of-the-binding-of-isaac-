-- Press a key to browse item names using ItemConfig
local mod = RegisterMod("ItemConfigBrowser", 1)
local game = Game()

function mod:onPostRender()
    if Input.IsButtonPressed(Keyboard.KEY_P, 0) then
        Isaac.DebugString("=== Item Config Browser ===")
        local itemConfig = Isaac.GetItemConfig()
        for id = 1, 100 do
            local collectible = itemConfig:GetCollectible(id)
            if collectible then
                Isaac.DebugString("ID: " .. id .. " - " .. collectible.Name)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("ItemConfigBrowser loaded! Press P to browse item names.")
