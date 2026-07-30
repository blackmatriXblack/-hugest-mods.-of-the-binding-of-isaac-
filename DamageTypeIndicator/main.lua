-- =============================================================================
--  DamageTypeIndicator - The Binding of Isaac: Repentance
--  Briefly show what damage type you took when hit (fire, explosion, contact, projectile)
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DamageTypeIndicator", 1)
local game = Game()
local damageFlash = {active = false, dmgType = "", frameStart = 0, fadeTime = 90}

local DAMAGE_FLAGS = {
    [DamageFlag.DAMAGE_FIRE]        = {name = "FIRE",        r = 1, g = 0.4, b = 0.1},
    [DamageFlag.DAMAGE_EXPLOSION]   = {name = "EXPLOSION",   r = 1, g = 0.3, b = 0},
    [DamageFlag.DAMAGE_LASER]       = {name = "LASER",       r = 1, g = 0.2, b = 0.8},
    [DamageFlag.DAMAGE_SPIKES]      = {name = "SPIKES",      r = 0.6, g = 0.6, b = 0.6},
    [DamageFlag.DAMAGE_TNT]         = {name = "EXPLOSIVE",   r = 1, g = 0.5, b = 0},
    [DamageFlag.DAMAGE_POOP]        = {name = "CREEP",       r = 0.4, g = 0.2, b = 0},
    [DamageFlag.DAMAGE_DEVIL]       = {name = "DEVIL",       r = 0.8, g = 0, b = 0},
    [DamageFlag.DAMAGE_IV_BAG]      = {name = "SELF",        r = 0.6, g = 0.2, b = 0.6},
    [DamageFlag.DAMAGE_ACID]        = {name = "ACID",        r = 0.2, g = 1, b = 0.2},
}

function mod:onEntityDamage(target, amount, flags, source, countdown)
    if target.Type == EntityType.ENTITY_PLAYER and amount > 0 then
        local dtype = "CONTACT"
        local r, g, b_ = 1, 0.8, 0.2

        -- Check specific flags
        if flags & DamageFlag.DAMAGE_FIRE > 0 then
            dtype, r, g, b_ = DAMAGE_FLAGS[DamageFlag.DAMAGE_FIRE].name, 1, 0.4, 0.1
        elseif flags & DamageFlag.DAMAGE_EXPLOSION > 0 then
            dtype, r, g, b_ = DAMAGE_FLAGS[DamageFlag.DAMAGE_EXPLOSION].name, 1, 0.3, 0
        elseif flags & DamageFlag.DAMAGE_LASER > 0 then
            dtype, r, g, b_ = DAMAGE_FLAGS[DamageFlag.DAMAGE_LASER].name, 1, 0.2, 0.8
        elseif flags & DamageFlag.DAMAGE_SPIKES > 0 then
            dtype, r, g, b_ = DAMAGE_FLAGS[DamageFlag.DAMAGE_SPIKES].name, 0.6, 0.6, 0.6
        elseif flags & DamageFlag.DAMAGE_TNT > 0 then
            dtype, r, g, b_ = DAMAGE_FLAGS[DamageFlag.DAMAGE_TNT].name, 1, 0.5, 0
        elseif flags & DamageFlag.DAMAGE_POOP > 0 then
            dtype, r, g, b_ = DAMAGE_FLAGS[DamageFlag.DAMAGE_POOP].name, 0.4, 0.2, 0
        elseif flags & DamageFlag.DAMAGE_DEVIL > 0 then
            dtype, r, g, b_ = DAMAGE_FLAGS[DamageFlag.DAMAGE_DEVIL].name, 0.8, 0, 0
        elseif source and source.Entity and source.Entity:IsEnemy() then
            local enemyType = source.Entity.Type
            -- Check if projectile from enemy
            dtype, r, g, b_ = "HIT", 1, 0.2, 0.2
        end

        damageFlash.active = true
        damageFlash.dmgType = dtype
        damageFlash.frameStart = game:GetFrameCount()
        damageFlash.r, damageFlash.g, damageFlash.b = r, g, b_
        damageFlash.amount = amount
    end
end

function mod:onRender()
    if not damageFlash.active then return end

    local elapsed = game:GetFrameCount() - damageFlash.frameStart
    if elapsed > damageFlash.fadeTime then
        damageFlash.active = false
        return
    end

    local alpha = 1.0 - (elapsed / damageFlash.fadeTime)
    local sw = Isaac.GetScreenWidth()
    local sh = Isaac.GetScreenHeight()
    local x = sw * 0.42
    local y = sh * 0.15

    local r, g, b = damageFlash.r, damageFlash.g, damageFlash.b

    Isaac.RenderScaledText(
        string.format("-%.1f %s", damageFlash.amount, damageFlash.dmgType),
        x, y, 1.6, 1.6 + (1.0 - alpha) * 0.5, r, g, b, alpha
    )
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityDamage)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("DamageTypeIndicator loaded!")
