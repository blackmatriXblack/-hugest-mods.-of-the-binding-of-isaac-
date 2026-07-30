-- ==========================================================================
--  Bag of Crafting Hint - The Binding of Isaac: Repentance
--  Bag of Crafting shows quality tier of the resulting item as color hint
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("BagOfCraftingHint", 1)
local game = Game()

local BAG = CollectibleType.COLLECTIBLE_BAG_OF_CRAFTING
local CRAFTING_PEDESTAL = EntityType.ENTITY_PICKUP

function mod:onRender()
    local player = Isaac.GetPlayer(0)
    if not player or not player:HasCollectible(BAG) then return end

    local room = game:GetRoom()
    for i = 0, 127 do
        local ent = room:GetEntity(i)
        if ent then
            local pickup = ent:ToPickup()
            if pickup and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                -- Check if near a crafting bag slot (within 60px of slot positions)
                local itemConfig = Isaac.GetItemConfig()
                local item = itemConfig:GetCollectible(pickup.SubType)
                if item then
                    local quality = item.Quality
                    local color
                    if quality >= 3 then color = "Q4 Gold" -- Quality 4
                    elseif quality == 2 then color = "Q3 Purple" -- Quality 3
                    elseif quality == 1 then color = "Q2 Blue" -- Quality 2
                    else color = "Q1 Gray" -- Quality 0-1
                    end
                    local pos = Isaac.WorldToScreen(pickup.Position)
                    Isaac.RenderText(color, pos.X - 20, pos.Y - 30, 1, 1, 1, 0.8, 0.8)
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("BagOfCraftingHint loaded!")
