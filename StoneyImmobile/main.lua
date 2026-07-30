-- =============================================================================
--  StoneyImmobile - The Binding of Isaac: Repentance
--  Stoney turns into an immobile statue for 3 seconds after taking damage
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("StoneyImmobile", 1)
local STONEY_TYPE = 302 -- EntityType.ENTITY_STONEY
local STATUE_DURATION = 90 -- 3 seconds at 30fps
local stoneTimers = {} -- entity index -> remaining statue frames

local function onTakeDamage(_, entity, amount, flags, source, cooldown)
    if entity.Type ~= STONEY_TYPE or not entity:Exists() then
        return
    end

    local idx = entity.Index
    stoneTimers[idx] = STATUE_DURATION

    -- Freeze in place immediately
    entity.Velocity = Vector(0, 0)
    entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
    entity:AddEntityFlags(EntityFlag.FLAG_FREEZE)

    -- Cosmetic: make it look stone-like
    local color = Color(0.6, 0.6, 0.6, 1, 0, 0, 0)
    entity:SetColor(color, 999, 0, false, true)
end

local function onNPCUpdate(_, entity)
    if entity.Type ~= STONEY_TYPE or not entity:Exists() then
        return
    end

    local idx = entity.Index
    if stoneTimers[idx] and stoneTimers[idx] > 0 then
        stoneTimers[idx] = stoneTimers[idx] - 1
        entity.Velocity = Vector(0, 0) -- force immobile

        if stoneTimers[idx] <= 0 then
            stoneTimers[idx] = nil
            -- Restore normal color
            local normalColor = Color(1, 1, 1, 1, 0, 0, 0)
            entity:SetColor(normalColor, 10, 0, false, true)
            entity:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
            entity:ClearEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, onTakeDamage)
mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("StoneyImmobile loaded!")
