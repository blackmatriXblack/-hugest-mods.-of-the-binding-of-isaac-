-- =============================================================================
--  RunSummaryScreen - The Binding of Isaac: Repentance
--  Show a summary overlay on pause screen: total kills, damage dealt, items collected, rooms cleared
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RunSummaryScreen", 1)
local game = Game()

-- Run tracking variables
local runStats = {
    totalKills = 0,
    totalDamageDealt = 0,
    totalDamageTaken = 0,
    itemsCollected = 0,
    roomsCleared = 0,
    bossesKilled = 0,
    pickupsCollected = 0,
    floorsVisited = 0,
}

function mod:onEntityKill(entity)
    if entity:IsEnemy() then
        runStats.totalKills = runStats.totalKills + 1
        if entity:IsBoss() then
            runStats.bossesKilled = runStats.bossesKilled + 1
        end
    end
end

function mod:onEntityDamage(target, amount, flags, source, countdown)
    if target.Type == EntityType.ENTITY_PLAYER and amount > 0 then
        runStats.totalDamageTaken = runStats.totalDamageTaken + amount
    end
    if source and source.Entity and source.Entity:ToPlayer() and target:IsEnemy() then
        runStats.totalDamageDealt = runStats.totalDamageDealt + amount
    end
end

function mod:onPickupCollision(pickup, collider, low)
    if collider and collider:ToPlayer() then
        if pickup.Variant == PickupVariant.PICKUP_COLLECTIBLE then
            runStats.itemsCollected = runStats.itemsCollected + 1
        end
        runStats.pickupsCollected = runStats.pickupsCollected + 1
    end
end

function mod:onNewLevel()
    runStats.floorsVisited = runStats.floorsVisited + 1
end

function mod:onRoomClear()
    runStats.roomsCleared = runStats.roomsCleared + 1
end

function mod:onRender()
    -- Only show when paused
    if not game:IsPaused() then return end

    local sw = Isaac.GetScreenWidth()
    local sh = Isaac.GetScreenHeight()

    -- Semi-transparent overlay background
    local cx = sw * 0.5
    local cy = sh * 0.4

    -- Title
    Isaac.RenderScaledText("RUN SUMMARY", cx - 80, cy - 60, 1.6, 1.6, 1, 0.8, 0.2, 1)

    local stats = {
        {label = "Total Kills",       value = tostring(runStats.totalKills),         r = 1, g = 0.6, b = 0.3},
        {label = "Bosses Killed",     value = tostring(runStats.bossesKilled),        r = 1, g = 0.3, b = 0.3},
        {label = "Damage Dealt",      value = string.format("%.0f", runStats.totalDamageDealt), r = 1, g = 0.3, b = 0.3},
        {label = "Damage Taken",      value = string.format("%.0f", runStats.totalDamageTaken), r = 1, g = 0.5, b = 0.5},
        {label = "Items Collected",   value = tostring(runStats.itemsCollected),      r = 1, g = 0.9, b = 0.3},
        {label = "Total Pickups",     value = tostring(runStats.pickupsCollected),    r = 0.5, g = 1, b = 0.5},
        {label = "Rooms Cleared",     value = tostring(runStats.roomsCleared),        r = 0.4, g = 0.7, b = 1},
        {label = "Floors Visited",    value = tostring(runStats.floorsVisited),       r = 0.7, g = 0.4, b = 1},
    }

    for i, stat in ipairs(stats) do
        local row = (i - 1) // 2
        local col = (i - 1) % 2
        local sx = cx - 140 + col * 280
        local sy = cy - 30 + row * 40

        -- Label
        Isaac.RenderScaledText(stat.label .. ":", sx, sy, 0.8, 0.8, 0.8, 0.8, 0.8, 1)
        -- Value
        Isaac.RenderScaledText(stat.value, sx + 130, sy, 1.1, 1.1, stat.r, stat.g, stat.b, 1)
    end

    -- K/D ratio
    local kdRatio = runStats.totalDamageTaken > 0
        and runStats.totalDamageDealt / runStats.totalDamageTaken
        or runStats.totalDamageDealt
    Isaac.RenderScaledText(
        string.format("K/D Ratio: %.1f", kdRatio),
        cx - 60, cy + 130, 1.0, 1.0, 0.3, 1, 0.3, 1
    )

    -- Bottom note
    Isaac.RenderScaledText(
        "Unpause to continue...",
        cx - 70, cy + 160, 0.6, 0.6, 0.4, 0.4, 0.4, 0.7
    )
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onEntityKill)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityDamage)
mod:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, mod.onPickupCollision)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.onNewLevel)
mod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, mod.onRoomClear)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("RunSummaryScreen loaded!")
