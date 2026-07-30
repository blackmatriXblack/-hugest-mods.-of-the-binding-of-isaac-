-- ==========================================================================
--  Glitched Crown Predict - The Binding of Isaac: Repentance
--  Glitched Crown cycle pattern displayed as text on screen
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("GlitchedCrownPredict", 1)
local game = Game()

local GLITCHED_CROWN = CollectibleType.COLLECTIBLE_GLITCHED_CROWN
local cycleItems = {}
local currentIndex = 0
local lastUpdateFrame = 0

function mod:onRender()
    local player = Isaac.GetPlayer(0)
    if not player or not player:HasCollectible(GLITCHED_CROWN) then return end

    -- Glitched Crown cycles through 5 items rapidly on each pedestal
    -- Display the current item in the cycle for the nearest pedestal
    local room = game:GetRoom()
    local nearestPedestal = nil
    local nearestDist = 999999

    for i = 0, 127 do
        local ent = room:GetEntity(i)
        if ent then
            local pickup = ent:ToPickup()
            if pickup and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                local dist = (player.Position - pickup.Position):Length()
                if dist < nearestDist and dist < 200 then
                    nearestDist = dist
                    nearestPedestal = pickup
                end
            end
        end
    end

    if nearestPedestal then
        -- Glitched crown cycles every ~4 frames between 5 items
        local frame = game:GetFrameCount() % 20
        local cyclePos = math.floor(frame / 4) + 1 -- 1-5
        local cycleText = "Cycle: " .. cyclePos .. "/5"
        local itemConfig = Isaac.GetItemConfig()
        local baseItem = itemConfig:GetCollectible(nearestPedestal.SubType)

        local screenPos = Isaac.WorldToScreen(nearestPedestal.Position)
        Isaac.RenderText(cycleText,
            screenPos.X - 25, screenPos.Y - 40, 1, 0.2, 0.8, 1, 0.8)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("GlitchedCrownPredict loaded!")
