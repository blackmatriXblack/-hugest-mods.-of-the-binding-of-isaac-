-- ==========================================================================
--  CritterReaction - The Binding of Isaac: Repentance
--  Enemies recoil and flinch when hit with velocity knockback boost!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("CritterReaction", 1)

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, source, countdown)
    if not entity:IsVulnerableEnemy() then return end

    local dir = Vector(0, -1)
    if source and source.Entity then
        dir = (entity.Position - source.Entity.Position):Normalized()
    end

    local knockback = 3 + amount * 0.5
    if entity:IsBoss() then knockback = knockback * 0.3 end

    entity.Velocity = dir * knockback + Vector(math.random(-2, 2), -3 - amount * 0.3)

    local spr = entity:GetSprite()
    if spr then
        spr:Play("Hit", true)
        spr.Scale = Vector(0.8, 0.8)
        spr:LoadGraphics()
    end

    local flinch = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.IMPACT, 0,
        entity.Position + dir * 10, Vector.Zero, entity)
    if flinch then flinch:SetTimeout(5) end

    entity:SetColor(Color(3, 2, 1.5, 1, 0, 0, 0), 3, 1, false, true)

    if entity.HitPoints <= 0 then
        entity.Velocity = dir * 10 + Vector(0, -8)
    end
end)

Isaac.DebugString("CritterReaction loaded! Flinch city!")
