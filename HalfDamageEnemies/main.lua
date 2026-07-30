-- =============================================================================
--  HalfDamageEnemies - The Binding of Isaac: Repentance
--  All enemies have 50% HP but deal 2x damage
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("HalfDamageEnemies", 1)
local game = Game()
local enemiesAdjusted = {}

function mod:onPostEntitySpawn(entity)
    if not entity:IsActiveEnemy() then return end
    if entity:IsBoss() then return end -- Bosses unchanged for fairness

    -- Skip if already adjusted
    local uid = entity.Index
    if enemiesAdjusted[uid] then return end

    -- Halve the enemy's HP
    local maxHP = entity.MaxHitPoints
    local newMaxHP = math.max(1, math.floor(maxHP * 0.5))
    entity.MaxHitPoints = newMaxHP
    entity.HitPoints = math.min(entity.HitPoints, newMaxHP)

    -- Color tint to indicate half HP (slightly desaturated/grey)
    entity:SetColor(Color(0.7, 0.7, 0.7, 1.0, 0, 0, 0), 30, 0)

    enemiesAdjusted[uid] = true

    -- Cleanup periodically
    if game:GetFrameCount() % 600 == 0 then
        enemiesAdjusted = {}
    end
end

function mod:onEntityTakeDmg(target, amount, flags, source, countdown)
    -- Apply 2x damage when the player takes damage from an enemy
    if target.Type == EntityType.ENTITY_PLAYER and amount > 0 then
        local player = target:ToPlayer()
        if not player then return end

        -- Double the damage (apply additional damage)
        if source.Entity and source.Entity:IsActiveEnemy() then
            -- Re-apply damage to make it effectively 2x
            -- We can't modify `amount` in the return, so we deal extra damage
            player:TakeDamage(amount, flags, source, countdown)
            -- Return the original amount (total = 2x)
        end
    end
end

function mod:onPostRender()
    -- Show mode indicator on HUD
    Isaac.RenderText(
        "[HALF HP / 2X DMG MODE]",
        200, 4,
        0.9, 0.5, 0.1, 0.7
    )
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onPostEntitySpawn)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)

Isaac.DebugString("HalfDamageEnemies loaded! Enemies are fragile but deadly.")
