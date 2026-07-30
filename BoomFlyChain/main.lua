-- =============================================================================
--  BoomFlyChain — The Binding of Isaac: Repentance
--  Boom Flies (Type=13) explode with bigger radius (120) and create fire.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BoomFlyChain", 1)

function mod:onEntityKill(entity)
    if entity.Type == 13 and entity.Variant == 0 then
        local pos = entity.Position
        Isaac.Explode(pos, entity, 120)
        for x = -1, 1 do
            for y = -1, 1 do
                if math.random() < 0.5 then
                    local firePos = pos + Vector(x * 40, y * 40)
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.FIRE, 0, firePos, Vector.Zero, entity)
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onEntityKill)
Isaac.DebugString("BoomFlyChain loaded!")
