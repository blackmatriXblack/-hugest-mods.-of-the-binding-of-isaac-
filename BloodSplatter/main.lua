-- ==========================================================================
--  BloodSplatter - The Binding of Isaac: Repentance
--  Enemies spray blood particles in damage direction when hit!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("BloodSplatter", 1)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, countdown)
    if not entity:IsVulnerableEnemy() then return end

    local dir = Vector(0, -1)
    if source then
        dir = (entity.Position - source.Position):Normalized()
    end

    local count = math.min(12, 4 + math.floor(amount * 0.3))
    for i = 1, count do
        local spread = (i / count - 0.5) * 2
        local angle = math.atan2(dir.Y, dir.X) + spread * 1.2
        local speed = math.random(3, 8)
        local vel = Vector(math.cos(angle) * speed, math.sin(angle) * speed - 2)
        local blood = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0,
            entity.Position, vel, entity)
        if blood then
            blood:SetTimeout(10 + math.random(0, 8))
            blood:SetColor(Color(0.8 + math.random() * 0.2,
                math.random() * 0.1, math.random() * 0.1, 1, 0, 0, 0), 0, 0)
        end
    end

    if amount > 10 then
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.LARGE_BLOOD_EXPLOSION, 0,
            entity.Position, Vector.Zero, entity):SetTimeout(5)
    end
end)

Isaac.DebugString("BloodSplatter loaded! Splatterfest!")
