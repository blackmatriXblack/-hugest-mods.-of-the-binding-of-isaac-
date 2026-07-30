-- ==========================================================================
--  Mirrored Damage - The Binding of Isaac: Repentance
--  50% of damage dealt to enemies is reflected back to the player
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("MirroredDamage", 1)
local game = Game()
local ReflectRatio = 0.5

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(tookDamage, entity, dmgAmount, dmgFlag, dmgSource, dmgCountdownFrames)
    -- Only track damage dealt TO enemies, and only when it would actually kill/hurt them
    if not entity:IsEnemy() then return end
    if dmgAmount <= 0 then return end

    local player = game:GetPlayer(0)
    if not player then return end

    -- Reflect portion of damage back to player
    local reflectDmg = dmgAmount * ReflectRatio
    if reflectDmg > 0 then
        local reflectActual = math.max(1, math.floor(reflectDmg * 2) / 2)
        -- Use a small delay to avoid crash loops
        player:TakeDamage(reflectActual, DamageFlag.DAMAGE_RED_HEARTS,
            EntityRef(entity), 0)
    end
end)

-- Visual indicator that mirrored damage is active
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    player:SetColor(Color(0.7, 0.4, 0.4, 1, 0, 0, 0), -1, 1, false, false)
end)

Isaac.DebugString("Mirrored Damage loaded!")
