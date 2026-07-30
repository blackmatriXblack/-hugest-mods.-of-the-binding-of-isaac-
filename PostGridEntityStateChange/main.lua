-- =============================================================================
--  PostGridEntityStateChange - The Binding of Isaac: Repentance
--  When TNT barrel lights: nearby enemies take 50% damage.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PostGridEntityStateChange", 1)

function mod:onPostGridEntityStateChange(grid, oldState)
    -- Only react to TNT barrels that changed to a lit/destroyed state
    if grid:GetType() ~= GridEntityType.GRID_TNT then return end
    local newState = grid:GetState()
    if newState == oldState then return end

    -- When TNT is lit (state 1-3) or destroyed (state 4), damage nearby enemies
    if newState >= 1 then
        local tntPos = grid.Position * 40 + Vector(20, 20) -- grid to world
        local entities = Isaac.GetRoomEntities()
        for _, entity in ipairs(entities) do
            if entity:IsVulnerableEnemy() and not entity:IsDead() then
                local dist = entity.Position:Distance(tntPos)
                if dist < 100 then
                    entity:TakeDamage(entity.HitPoints * 0.5, 0, EntityRef(grid), 0)
                end
            end
        end
        Isaac.DebugString("TNT barrel state change — nearby enemies damaged!")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_GRID_ENTITY_STATE_CHANGE, mod.onPostGridEntityStateChange)
Isaac.DebugString("PostGridEntityStateChange loaded!")
