-- =============================================================================
--  MegaChestSpawner — The Binding of Isaac: Repentance
--  Mega chests spawn 2 extra pickups when opened.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MegaChestSpawner", 1)

local MEGA_CHEST_TYPE = GridEntityType.GRID_CHEST
local MEGA_CHEST_VAR = 4

function mod:OnGridUpdate(grid)
    if grid:GetType() ~= MEGA_CHEST_TYPE then return end
    if grid:GetVariant() ~= MEGA_CHEST_VAR then return end

    if grid.State == 1 then
        local gridPos = grid.Position
        for j = 1, 2 do
            local spawnPos = gridPos + Vector(20 * j, 0)
            local rng = RNG()
            rng:SetSeed(grid:GetSaveState() + j, 0)
            local pickupTypes = {
                PickupVariant.PICKUP_HEART,
                PickupVariant.PICKUP_COIN,
                PickupVariant.PICKUP_KEY,
                PickupVariant.PICKUP_BOMB,
            }
            local pickType = pickupTypes[rng:RandomInt(#pickupTypes) + 1]
            Isaac.Spawn(
                EntityType.ENTITY_PICKUP,
                pickType,
                0,
                spawnPos,
                Vector(rng:RandomInt(3) - 1, rng:RandomInt(3) - 1),
                nil
            )
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.OnGridUpdate)
Isaac.DebugString("MegaChestSpawner loaded!")
