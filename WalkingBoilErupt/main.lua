-- =============================================================================
--  WalkingBoilErupt — The Binding of Isaac: Repentance
--  Walking Boils (Type=35) fire 8-way tears when killed.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("WalkingBoilErupt", 1)

function mod:onEntityKill(entity)
    if entity.Type == 35 then
        local pos = entity.Position
        for i = 0, 7 do
            local angle = math.pi * 2 * i / 8
            local dir = Vector(math.cos(angle), math.sin(angle))
            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, pos, dir * 5, entity)
            if tear then
                tear:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onEntityKill)
Isaac.DebugString("WalkingBoilErupt loaded!")
