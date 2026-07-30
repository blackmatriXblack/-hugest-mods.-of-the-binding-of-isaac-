-- ==========================================================================
--  Spindown Dice Buff - The Binding of Isaac: Repentance
--  Spindown Dice shows the resulting item name when hovering over pedestals
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SpindownDiceBuff", 1)
local game = Game()

local SPINDOWN = CollectibleType.COLLECTIBLE_SPINDOWN_DICE

function mod:onRender()
    local player = Isaac.GetPlayer(0)
    if not player or not player:HasCollectible(SPINDOWN) then return end
    if not player:HasCollectible(SPINDOWN) then return end

    local room = game:GetRoom()
    local itemConfig = Isaac.GetItemConfig()

    for i = 0, 127 do
        local ent = room:GetEntity(i)
        if ent then
            local pickup = ent:ToPickup()
            if pickup and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                local currentId = pickup.SubType
                -- Spindown Dice reduces item ID by 1
                local newId = currentId - 1
                if newId > 0 then
                    local newItem = itemConfig:GetCollectible(newId)
                    if newItem then
                        local name = newItem.Name
                        local screenPos = Isaac.WorldToScreen(pickup.Position)
                        Isaac.RenderText(name,
                            screenPos.X - 30, screenPos.Y - 50,
                            1, 1, 0.8, 0.2, 0.8)
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("SpindownDiceBuff loaded!")
