-- =============================================================================
--  KillComboTracker - The Binding of Isaac: Repentance
--  Track kill streaks! Every 10 kills without taking damage adds +0.5 damage temporarily
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("KillComboTracker", 1)
local game = Game()

local killStreak = 0
local bestStreak = 0
local comboBonus = 0
local tookDamage = false

function mod:onEntityKill(entity)
    if entity:IsEnemy() and not tookDamage then
        killStreak = killStreak + 1
        if killStreak > bestStreak then
            bestStreak = killStreak
        end

        -- Every 10 kills = +0.5 damage bonus
        local newBonus = math.floor(killStreak / 10) * 0.5
        if newBonus > comboBonus then
            comboBonus = newBonus
            local player = Isaac.GetPlayer(0)
            if player then
                player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
                player:EvaluateItems()
            end
        end
    end
end

function mod:onEntityDamage(target, amount, flags, source, countdown)
    if target.Type == EntityType.ENTITY_PLAYER then
        tookDamage = true
        -- Reset streak on damage taken
        killStreak = 0
        comboBonus = 0
        local player = target:ToPlayer()
        if player then
            player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
            player:EvaluateItems()
        end
    end
end

function mod:onCache(player, flag)
    if flag & CacheFlag.CACHE_DAMAGE > 0 then
        player.Damage = player.Damage + comboBonus
    end
end

function mod:onNewRoom()
    tookDamage = false
end

function mod:onRender()
    local sw = Isaac.GetScreenWidth()
    local sh = Isaac.GetScreenHeight()
    local x = sw * 0.44
    local y = sh * 0.02

    if killStreak == 0 and bestStreak == 0 then return end

    -- Combo title
    if killStreak > 0 then
        local pulse = math.abs(math.sin(game:GetFrameCount() * 0.08))
        local scale = 1.0 + pulse * 0.15
        local alpha = 0.7 + pulse * 0.3

        Isaac.RenderScaledText(
            string.format("KILL COMBO x%d", killStreak),
            x, y, scale, scale, 1, 1 - pulse * 0.3, 0.2, alpha
        )

        -- Damage bonus indicator
        if comboBonus > 0 then
            Isaac.RenderScaledText(
                string.format("(+%.1f DMG)", comboBonus),
                x, y + 22, 0.9, 0.9, 1, 0.6, 0.2, 0.9
            )
        end
    end

    -- Best streak
    if bestStreak > 0 then
        Isaac.RenderScaledText(
            string.format("Best: %d", bestStreak),
            x, y + 38, 0.65, 0.65, 0.6, 0.6, 0.6, 0.7
        )
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onEntityKill)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityDamage)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.onCache)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("KillComboTracker loaded!")
