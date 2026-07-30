-- =============================================================================
--  TearGravityWell - The Binding of Isaac: Repentance
--  Tears create a gravity well that pulls enemies toward impact points.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TearGravityWell", 1)

local wells = {} -- { pos, timer }

function mod:onTearCollision(tear, collider)
    if collider and collider.Type == EntityType.ENTITY_TEAR then return end

    local pos = tear.Position
    table.insert(wells, { pos = pos, timer = 90 })
end

function mod:onNpcUpdate()
    for i = #wells, 1, -1 do
        local w = wells[i]
        w.timer = w.timer - 1
        if w.timer <= 0 then
            table.remove(wells, i)
        end
    end

    local entities = Isaac.GetRoomEntities()
    for _, ent in ipairs(entities) do
        if ent:IsVulnerableEnemy() then
            for _, w in ipairs(wells) do
                local diff = w.pos - ent.Position
                local dist = diff:Length()
                if dist < 150 and dist > 10 then
                    local strength = (1 - dist / 150) * 0.8
                    ent.Velocity = ent.Velocity + diff:Normalized() * strength * 0.4
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_COLLISION, mod.onTearCollision)
mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("TearGravityWell loaded!")
