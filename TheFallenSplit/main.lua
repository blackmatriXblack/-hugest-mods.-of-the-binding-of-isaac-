-- =============================================================================
--  TheFallenSplit — The Binding of Isaac: Repentance
--  The Fallen (Type=47.0) splits into two at half HP (The Fallen + Krampus)
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TheFallenSplit", 1)

local FALLEN_TYPE = EntityType.ENTITY_FALLEN -- Type 47
local KRAMPUS_TYPE = EntityType.ENTITY_KRAMPUS -- Type 83

local hasSplit = {}

function mod:onEntityTakeDmg(target, damageAmount, damageFlag, damageSource, damageCountdownFrames)
    if target.Type ~= FALLEN_TYPE or target.Variant ~= 0 then
        return
    end

    local idx = GetPtrHash(target)
    if hasSplit[idx] then
        return
    end

    local hpPercent = target.HitPoints / target.MaxHitPoints

    if hpPercent <= 0.5 and target.HitPoints > 0 then
        hasSplit[idx] = true

        -- Spawn Krampus nearby
        local krampusPos = Vector(target.Position.X + 60, target.Position.Y)
        local krampus = Isaac.Spawn(KRAMPUS_TYPE, 0, 0, krampusPos, Vector.Zero, target)
        if krampus then
            krampus.HitPoints = target.MaxHitPoints / 2
        end

        -- Reduce The Fallen's HP to match
        target.HitPoints = target.MaxHitPoints / 2
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
Isaac.DebugString("TheFallenSplit loaded!")
