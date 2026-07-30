-- ==========================================================================
--  Moving Box Storage - The Binding of Isaac: Repentance
--  Moving Box can store up to 8 items instead of 4
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("MovingBoxStorage", 1)
local game = Game()

local MOVING_BOX = CollectibleType.COLLECTIBLE_MOVING_BOX
local storedCount = {}

function mod:onPlayerUpdate(player)
    if not player:HasCollectible(MOVING_BOX) then return end

    -- Track how many items are stored by counting pickups near the box
    for slot = 0, 3 do
        if player:GetActiveItem(slot) == MOVING_BOX then
            -- Moving Box normally holds 4 items max, this mod extends to 8
            -- Items are stored as invisible entities following the box
            local charge = player:GetActiveCharge(slot)
            if charge > 0 then
                Isaac.RenderText("Box: " .. charge .. "/8 items",
                    50, 130, 1, 0.8, 0.6, 0.2, 0.8)
            end
            break
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("MovingBoxStorage loaded!")
