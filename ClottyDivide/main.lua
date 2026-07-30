-- =============================================================================
--  ClottyDivide — The Binding of Isaac: Repentance
--  Clotties (Type=32) split into 2 smaller ones on death.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ClottyDivide", 1)

function mod:onEntityKill(entity)
    if entity.Type == 32 then
        local pos = entity.Position
        for i = 1, 2 do
            local child = Isaac.Spawn(EntityType.ENTITY_CLOTTY, 0, 0, pos, Vector.Zero, entity)
            if child then
                child.Scale = 0.7
                child.HitPoints = entity.MaxHitPoints * 0.3
                child.MaxHitPoints = entity.MaxHitPoints * 0.3
                child.Velocity = Vector(math.random(-2, 2), math.random(-2, 2))
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onEntityKill)
Isaac.DebugString("ClottyDivide loaded!")
