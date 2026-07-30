-- =============================================================================
--  HomeFloorTreasure — The Binding of Isaac: Repentance
--  The Home floor (final floor) has 2 extra random item rooms.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("HomeFloorTreasure", 1)

function mod:OnNewLevel()
    local level = Game():GetLevel()
    local stageType = level:GetStageType()

    if stageType ~= StageType.STAGETYPE_REPENTANCE_B then return end

    local room = level:GetCurrentRoom()
    local center = room:GetCenterPos()

    for i = 1, 2 do
        local spawnPos = center + Vector(-50 + 100 * i, 0)
        Isaac.Spawn(
            EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE,
            0,
            spawnPos,
            Vector.Zero,
            nil
        )
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.OnNewLevel)
Isaac.DebugString("HomeFloorTreasure loaded!")
