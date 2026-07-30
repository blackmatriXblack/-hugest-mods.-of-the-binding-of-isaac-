-- =============================================================================
--  RedBoomFlyMines — The Binding of Isaac: Repentance
--  Red Boom Flies (Type=13, Variant=1) leave 3 troll bombs when killed.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RedBoomFlyMines", 1)

function mod:onEntityKill(entity)
    if entity.Type == 13 and entity.Variant == 1 then
        local pos = entity.Position
        for i = 1, 3 do
            local offset = Vector(math.random(-40, 40), math.random(-40, 40))
            Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_TROLL, 0, pos + offset, Vector.Zero, entity)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onEntityKill)
Isaac.DebugString("RedBoomFlyMines loaded!")
