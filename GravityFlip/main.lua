-- =============================================================================
--  Gravity Flip - The Binding of Isaac: Repentance
--  Every 30 seconds, gravity flips / reversed knockback!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GravityFlip", 1)
local gravityReversed = false
local flipTimer = 0
local FLIP_INTERVAL = 30 * 30 -- 30 seconds at ~30fps

function mod:onPlayerUpdate(player)
    flipTimer = flipTimer + 1

    if flipTimer >= FLIP_INTERVAL then
        flipTimer = 0
        gravityReversed = not gravityReversed

        -- Announce gravity flip
        Game():ShakeScreen(8)
        if gravityReversed then
            Isaac.DebugString("Gravity FLIPPED! Knockback reversed!")
            -- Give brief anti-gravity visual
            player:AddBombs(0)
        else
            Isaac.DebugString("Gravity normal again!")
        end
    end

    -- Apply reversed knockback by adding opposite velocity
    if gravityReversed then
        local vel = player.Velocity
        if vel:Length() > 0.1 then
            player.Velocity = vel * -1.2 -- Reverse and amplify
        end
        -- Tint player blue when reversed
        player:GetSprite().Color = Color(0.5, 0.5, 1, 1, 0, 0, 0)
    else
        player:GetSprite().Color = Color(1, 1, 1, 1, 0, 0, 0)
    end
end

function mod:onEntityTakeDmg(tookDamage, amount, damageFlag, damageSource, damageCountdown)
    if tookDamage.Entity.Type == EntityType.ENTITY_PLAYER and gravityReversed then
        -- Reversed knockback on damage
        local player = tookDamage.Entity:ToPlayer()
        if player then
            local dir = player.Position - damageSource.Position
            player.Velocity = dir:Normalized() * 8
        end
    end
    return nil
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
Isaac.DebugString("GravityFlip loaded!")
