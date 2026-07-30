-- =============================================================================
--  GridCollisionTrap — The Binding of Isaac: Repentance
--  Walking over spikes has 30% chance to NOT trigger.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GridCollisionTrap", 1)

function mod:onGridCollision(grid, collider)
    if grid and collider and collider:IsPlayer() then
        -- Check if the grid entity is spikes
        local gridType = grid:GetType()
        if gridType == GridEntityType.GRID_SPIKES or
           gridType == GridEntityType.GRID_SPIKES_ONOFF then
            if math.random() <= 0.3 then
                -- 30% chance to negate spike damage
                -- Briefly toggle the spikes off to avoid triggering
                grid.State = 0
                -- Negative collision return to indicate no damage
                Isaac.DebugString("GridCollisionTrap: Spikes negated!")
                return false
            end
        end
    end
    return nil -- let normal handling proceed
end

mod:AddCallback(ModCallbacks.MC_POST_GRID_COLLISION, mod.onGridCollision)
Isaac.DebugString("GridCollisionTrap loaded!")
