-- =============================================================================
--  TriggerClearReward — The Binding of Isaac: Repentance
--  MC_POST_TRIGGER_CLEAR: 15% chance room clear spawns a bonus item
--  pedestal from the room's item pool.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TriggerClearReward", 1)

function mod:onPostTriggerClear(rng, isFirstClear)
    -- Only trigger on first clear
    if not isFirstClear then return end

    -- 15% chance
    if math.random(1, 100) > 15 then return end

    local room = Game():GetRoom()
    if not room then return end

    local center = room:GetCenterPos()
    local itemPool = Game():GetItemPool()
    local itemID = itemPool:GetCollectible(room:GetType())

    if itemID and itemID > 0 then
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            itemID,
            center,
            Vector.Zero,
            nil
        )
    end
end
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_CLEAR, mod.onPostTriggerClear)

Isaac.DebugString("TriggerClearReward loaded!")
