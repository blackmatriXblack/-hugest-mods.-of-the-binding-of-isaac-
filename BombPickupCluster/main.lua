-- =============================================================================
--  BombPickupCluster — The Binding of Isaac: Repentance
--  Bomb pickups spawn in clusters of 3 instead of 1.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BombPickupCluster", 1)

local CLUSTER_SIZE = 3

function mod:SpawnBombCluster(pickup, variant, subtype)
    if variant == PickupVariant.PICKUP_BOMB then
        if pickup.SpawnerType == 0 then return end  -- avoid infinite recursion

        local pos = pickup.Position
        for i = 1, CLUSTER_SIZE - 1 do
            local offset = Vector(math.random(-20, 20), math.random(-20, 20))
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB,
                pickup.SubType, pos + offset, Vector.Zero, nil)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PICKUP_INIT, mod.SpawnBombCluster)
Isaac.DebugString("BombPickupCluster loaded!")
