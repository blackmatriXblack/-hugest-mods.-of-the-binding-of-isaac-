-- ==========================================================================
--  Flip Double Reward - The Binding of Isaac: Repentance
--  Tainted Lazarus Flip gives both ghost and alive item rewards
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("FlipDoubleReward", 1)
local game = Game()

local FLIP = CollectibleType.COLLECTIBLE_FLIP
local lastFlipFrame = 0

function mod:onUseItem(itemType, rng, player)
    if itemType ~= FLIP then return end
    if game:GetFrameCount() - lastFlipFrame < 2 then return end

    lastFlipFrame = game:GetFrameCount()

    -- After flipping, trigger both the ghost and alive pickup automatically
    -- Find the nearest pedestal item in the room
    local room = game:GetRoom()
    for i = 0, 127 do
        local ent = room:GetEntity(i)
        if ent then
            local pickup = ent:ToPickup()
            if pickup and pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                -- Spawn a second copy of the item as the alternate reward
                local pos = pickup.Position
                local altItem = Isaac.Spawn(EntityType.ENTITY_PICKUP,
                    PickupVariant.PICKUP_COLLECTIBLE, pickup.SubType,
                    pos + Vector(20, 0), Vector.Zero, player)
                if altItem then
                    Isaac.DebugString("FlipDoubleReward: spawned alt item")
                end
                break
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.onUseItem, FLIP)
Isaac.DebugString("FlipDoubleReward loaded!")
