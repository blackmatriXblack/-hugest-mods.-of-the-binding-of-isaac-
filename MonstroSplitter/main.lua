-- =============================================================================
--  MonstroSplitter — The Binding of Isaac: Repentance
--  Monstro (Type=20) splits into 2 mini-Monstros at 50% HP
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MonstroSplitter", 1)

local SPLIT_THRESHOLD = 0.5
local MINI_MONSTRO_TYPE = EntityType.ENTITY_MONSTRO
local MINI_MONSTRO_VARIANT = 1
local MONSTRO_TYPE = EntityType.ENTITY_MONSTRO
local MONSTRO_VARIANT = 0

local hasSplit = {}

function mod:onEntityTakeDmg(target, damageAmount, damageFlag, damageSource, damageCountdownFrames)
    if target.Type ~= MONSTRO_TYPE or target.Variant ~= MONSTRO_VARIANT then
        return
    end

    local idx = GetPtrHash(target)
    if hasSplit[idx] then
        return
    end

    local currentHP = target.HitPoints
    local maxHP = target.MaxHitPoints

    if currentHP > 0 and maxHP > 0 and (currentHP / maxHP) <= SPLIT_THRESHOLD then
        hasSplit[idx] = true

        local room = Game():GetRoom()
        for i = 1, 2 do
            local offsetX = (i == 1 and -40) or 40
            local spawnPos = Vector(target.Position.X + offsetX, target.Position.Y)
            local mini = Isaac.Spawn(MINI_MONSTRO_TYPE, MINI_MONSTRO_VARIANT, 0, spawnPos, Vector.Zero, target)
            if mini then
                mini.HitPoints = target.MaxHitPoints / 2
            end
        end

        target:Kill()
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
Isaac.DebugString("MonstroSplitter loaded!")
