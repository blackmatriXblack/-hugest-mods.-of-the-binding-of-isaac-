-- =============================================================================
--  PaleFattySplit - The Binding of Isaac: Repentance
--  Pale Fatties split into a Fatty and a Gaper upon death
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PaleFattySplit", 1)
local PALE_FATTY_TYPE = 208
local FATTY_TYPE = 12
local GAPER_TYPE = 35

function mod:onNpcDeath(_, npc)
    if npc.Type ~= PALE_FATTY_TYPE then return end
    local pos = npc.Position
    local room = Game():GetRoom()

    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCKET_EXPLOSION, 0, pos, Vector.Zero, npc)

    local fattyPos = pos + Vector(-35, math.random(-10, 10))
    fattyPos = room:GetClampedPosition(fattyPos, 25)
    local fatty = Isaac.Spawn(FATTY_TYPE, 0, 0, fattyPos, RandomVector():Resized(2), npc)
    if fatty then
        fatty:AddEntityFlags(EntityFlag.FLAG_APPEAR)
        fatty.HitPoints = fatty.MaxHitPoints * 0.6
        fatty.Scale = 0.85
    end

    local gaperPos = pos + Vector(35, math.random(-10, 10))
    gaperPos = room:GetClampedPosition(gaperPos, 25)
    local gaper = Isaac.Spawn(GAPER_TYPE, 0, 0, gaperPos, RandomVector():Resized(2), npc)
    if gaper then
        gaper:AddEntityFlags(EntityFlag.FLAG_APPEAR)
        gaper.HitPoints = gaper.MaxHitPoints * 0.5
        gaper.Scale = 0.8
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.onNpcDeath)
Isaac.DebugString("PaleFattySplit loaded!")
